import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv/csv.dart';
import 'storage_service.dart';
import 'report_data.dart';

// Klíče pro ukládání adres
const String _csvUrlKey = 'csv_url';
const String _ebulaBaseUrlKey = 'ebula_base_url';

class WebLoaderPage extends StatefulWidget {
  const WebLoaderPage({super.key});

  @override
  State<WebLoaderPage> createState() => _WebLoaderPageState();
}

class _WebLoaderPageState extends State<WebLoaderPage> {
  final _csvUrlController = TextEditingController();
  final _ebulaUrlController = TextEditingController();
  String _statusMessage = '';
  bool _isLoading = false;

  // Použití `mounted` checku pro bezpečné volání `setState`
  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUrls();
  }

  @override
  void dispose() {
    _csvUrlController.dispose();
    _ebulaUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadUrls() async {
    final prefs = await SharedPreferences.getInstance();
    // V initState není třeba setState, ale pro konzistenci
    // s možným budoucím voláním je bezpečnější to zde nechat
    // a ošetřit přes mounted check.
    _safeSetState(() {
      _csvUrlController.text = prefs.getString(_csvUrlKey) ?? '';
      _ebulaUrlController.text = prefs.getString(_ebulaBaseUrlKey) ?? '';
    });
  }

  Future<void> _saveUrls() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_csvUrlKey, _csvUrlController.text);
    await prefs.setString(_ebulaBaseUrlKey, _ebulaUrlController.text);
  }

  Future<void> _triggerSync() async {
    if (_isLoading) return;

    _safeSetState(() {
      _isLoading = true;
      _statusMessage = 'Zahajuji synchronizaci...';
    });

    bool syncSuccess = false;
    try {
      await _saveUrls();
      // Vytvoření instance služby, aby byla logika oddělená a testovatelná
      final syncService = WebSyncService();
      final result = await syncService.syncFromWeb(
        csvUrl: _csvUrlController.text,
        ebulaBaseUrl: _ebulaUrlController.text,
      );
      _safeSetState(() => _statusMessage = result);
      syncSuccess = true;
    } on SyncException catch (e) {
      _safeSetState(() => _statusMessage = 'Chyba: ${e.message}');
    } catch (e) {
      _safeSetState(() => _statusMessage = 'Nastala neočekávaná chyba: $e');
    } finally {
      _safeSetState(() => _isLoading = false);
      // Pokud synchronizace proběhla úspěšně, zavři stránku a vrať výsledek.
      if (syncSuccess && mounted) {
        // Počkej chvíli, aby si uživatel stihl přečíst zprávu o úspěchu
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop(true); // Vrací `true` jako signál k obnovení
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Načítání z webu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _csvUrlController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'URL CSV souboru s brzděnkou',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ebulaUrlController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'URL složky s eBula TXT soubory',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _triggerSync,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3),
              )
                  : const Text('Načíst a synchronizovat'),
            ),
            const SizedBox(height: 24),
            if (_statusMessage.isNotEmpty)
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _statusMessage.startsWith('Chyba')
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Vlastní, specifická výjimka pro chyby synchronizace
class SyncException implements Exception {
  final String message;
  SyncException(this.message);
  @override
  String toString() => message;
}

/// Služba obsahující logiku pro synchronizaci
class WebSyncService {
  Future<String> syncFromWeb({String? csvUrl, String? ebulaBaseUrl}) async {
    final prefs = await SharedPreferences.getInstance();
    final finalCsvUrl = csvUrl ?? prefs.getString(_csvUrlKey);
    final finalEbulaBaseUrl = ebulaBaseUrl ?? prefs.getString(_ebulaBaseUrlKey);

    if (finalCsvUrl == null || finalCsvUrl.isEmpty) {
      throw SyncException('URL pro CSV není nastaveno.');
    }
    if (finalEbulaBaseUrl == null || finalEbulaBaseUrl.isEmpty) {
      throw SyncException('URL pro eBula není nastaveno.');
    }

    final client = http.Client();
    try {
      // --- CSV ---
      final trains = await _downloadAndParseCsv(client, finalCsvUrl);
      await StorageService.saveTrains(trains);

      // --- eBula TXT ---
      final summary = await _downloadEbulaFiles(client, trains, finalEbulaBaseUrl);

      return 'Úspěch: CSV a ${summary.downloaded} eBula souborů staženo. (${summary.failed} chyb.)';
    } on TimeoutException {
      throw SyncException('Vypršel časový limit pro připojení k serveru.');
    } on SocketException {
      throw SyncException('Nelze se připojit k serveru. Zkontrolujte připojení.');
    } on FormatException {
      throw SyncException('Zadaná URL adresa má neplatný formát.');
    } catch (e) {
      // Pokud to není naše výjimka, zabalíme ji pro lepší kontext
      if (e is! SyncException) {
        throw SyncException('Při synchronizaci nastala chyba: $e');
      }
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<List<ReportData>> _downloadAndParseCsv(
      http.Client client, String url) async {
    final response =
    await client.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw SyncException(
          'Nelze stáhnout CSV (server odpověděl: ${response.statusCode})');
    }

    final rows = const CsvToListConverter(eol: '\n').convert(response.body);
    if (rows.length <= 1) {
      throw SyncException('CSV je prázdné nebo obsahuje pouze hlavičku.');
    }

    // .map().toList() je efektivnější než for cyklus s manuálním přidáváním
    return rows
        .skip(1)
        .map((row) => ReportData.fromCsvRow(
        row.map((e) => e.toString()).toList()))
        .toList();
  }

  Future<({int downloaded, int failed})> _downloadEbulaFiles(
      http.Client client,
      List<ReportData> trains,
      String baseUrl,
      ) async {
    int downloaded = 0;
    int failed = 0;
    final finalBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

    // Paralelní stahování pro zrychlení
    final downloadTasks = <Future>[];

    for (final train in trains) {
      final number = train.trainNumber.trim();
      if (number.isEmpty) continue;

      final task = () async {
        try {
          final uri = Uri.parse('$finalBaseUrl$number.txt');
          final response = await client.get(uri).timeout(const Duration(seconds: 8));
          if (response.statusCode == 200) {
            await StorageService.saveTjrFile(number, response.body);
            downloaded++;
          } else {
            failed++;
          }
        } catch (_) {
          failed++;
        }
      }();
      downloadTasks.add(task);
    }

    await Future.wait(downloadTasks); // Čeká na dokončení všech stahování
    return (downloaded: downloaded, failed: failed);
  }
}

/// 🔄 Automatická synchronizace při startu aplikace
Future<void> runStartupSync() async {
  print("Spouštění automatické synchronizace...");
  try {
    final result = await WebSyncService().syncFromWeb();
    print("Automatická synchronizace: $result");
  } catch (e) {
    print("Automatická synchronizace selhala: $e");
  }
}
