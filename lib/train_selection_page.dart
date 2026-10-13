import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'database/app_database.dart'; 
import 'database/db_provider.dart';  
import 'settings_screen.dart';       

import 'report_page.dart';
import 'storage_service.dart';
import 'train_edit_list_page.dart';
import 'train_tjr_view_page.dart';
import 'main.dart'; 

class TrainSelectionPage extends StatefulWidget {
  const TrainSelectionPage({super.key});

  @override
  State<TrainSelectionPage> createState() => _TrainSelectionPageState();
}

class _TrainSelectionPageState extends State<TrainSelectionPage> {
  List<Train> trains = [];
  List<Train> filteredTrains = [];
  String _appVersion = "";
  String _filter = "";

  @override
  void initState() {
    super.initState();
    _loadTrains();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${info.version}+${info.buildNumber}";
    });
  }

  Future<void> _loadTrains() async {
    final loaded = await db.getAllTrains();
    if (!mounted) return;
    
    setState(() {
      trains = loaded;
      _applyFilter(_filter);
    });
  }

  void _applyFilter(String query) {
    setState(() {
      _filter = query;
      filteredTrains = trains.where((t) {
        final name = t.trainName?.toLowerCase() ?? '';
        final number = t.trainNumber?.toString().toLowerCase() ?? '';
        
        return name.contains(query.toLowerCase()) ||
            number.contains(query.toLowerCase());
      }).toList();
    });
  }

  // ==========================================
  // NOVÉ: EXPORT A IMPORT DATABÁZE (SQLITE)
  // ==========================================

  Future<void> _exportDatabase() async {
    final destPath = await StorageService.exportDatabase();
    if (!mounted) return;

    if (destPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Databáze úspěšně exportována do:\n$destPath"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Export databáze selhal (chybí oprávnění nebo složka)"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _importDatabase() async {
    // 1. Zobrazíme varování, protože přepisujeme všechna lokální data
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Importovat databázi?"),
        content: const Text(
            "Tato akce kompletně a nevratně přepíše vaši současnou databázi vlaků. "
            "Opravdu chcete pokračovat?"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Zrušit"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Přepsat data",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. Výběr souboru
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Vyber SQLite databázi',
        type: FileType.custom,
        allowedExtensions: ['sqlite', 'db'],
        withData: true,
      );
      
      if (result == null) return;
      
      final pickedFile = result.files.single;
      final bytes = await _readPickedFile(pickedFile);
      
      if (bytes == null) {
        _showImportMessage('Soubor se nepodařilo přečíst.');
        return;
      }

      // 3. Provedení importu a následné restartování připojení k databázi
      final success = await StorageService.importDatabase(bytes);
      
      if (success) {
        _showImportMessage('Databáze byla úspěšně nahrána!', color: Colors.green);
        // POZOR: Abys viděl nové vlaky, musíme Driftu říct, ať se na ten soubor podívá znovu
        await _loadTrains(); 
      } else {
        _showImportMessage('Chyba při nahrávání databáze.', color: Colors.red);
      }
      
    } catch (e) {
      _showImportMessage('Import selhal: $e', color: Colors.red);
    }
  }

  void _showImportMessage(String message, {Color color = Colors.white}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // ==========================================

  Future<void> _importTjrFiles() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Vyber TJŘ TXT soubory',
      type: FileType.any,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    var importedCount = 0;
    for (final pickedFile in result.files) {
      if (!pickedFile.name.toLowerCase().endsWith('.txt')) continue;
      final bytes = await _readPickedFile(pickedFile);
      if (bytes == null) continue;

      await StorageService.importTjrFile(pickedFile.name, bytes);
      importedCount++;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Importováno TJŘ souborů: $importedCount')),
    );
  }

  Future<List<int>?> _readPickedFile(PlatformFile pickedFile) async {
    if (pickedFile.bytes != null) return pickedFile.bytes;
    final path = pickedFile.path;
    if (path == null) return null;

    final file = File(path);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  Future<void> _navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
    await _loadTrains();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        
        title: GestureDetector(
          onLongPress: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
          child: const Text("Výběr vlaku"),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            tooltip: "Nastavení a synchronizace webu",
            onPressed: _navigateToSettings,
          ),
          IconButton(
            icon: const Icon(Icons.description),
            tooltip: "Importovat TJŘ soubory ručně",
            onPressed: _importTjrFiles,
          ),
          
          // --- PŘIDÁNO ZPĚT TLAČÍTKO PRO IMPORT DATABÁZE ---
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Importovat lokální databázi (.sqlite)",
            onPressed: _importDatabase,
          ),
          
          if (Platform.isWindows || Platform.isLinux) ...[
            // --- PŘIDÁNO ZPĚT TLAČÍTKO PRO EXPORT DATABÁZE ---
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: "Exportovat databázi k odeslání na web",
              onPressed: _exportDatabase,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editor vlaků",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainEditListPage(),
                  ),
                ).then((_) => _loadTrains());
              },
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Filtrovat podle názvu nebo čísla vlaku...",
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _applyFilter,
            ),
          ),
          Expanded(
            child: trains.isEmpty
                ? const Center(
                    child: Text(
                      "Nenalezeny žádné uložené vlaky. Zkontrolujte nastavení.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTrains.length,
                    itemBuilder: (context, index) {
                      final train = filteredTrains[index];
                      
                      final tName = train.trainName ?? "Neznámý";
                      final tNum = train.trainNumber?.toString() ?? "???";
                      final tSpeed = train.maxSpeed?.toString() ?? "N/A";
                      
                      return Card(
                        color: const Color(0xFF1E1E1E),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(
                            "$tName ($tNum)",
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "Rychlost: $tSpeed km/h",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.table_chart,
                                    color: Colors.lightBlueAccent),
                                tooltip: "Otevřít brzděnku",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportPage(data: train.toReportData()),
                                    ),
                                  ).then((_) => _loadTrains());
                                },
                              ),
                              if (tNum != "???")
                                IconButton(
                                  icon: const Icon(Icons.description,
                                      color: Colors.amberAccent),
                                  tooltip: "Zobrazit jízdní řád (TJŘ)",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TrainTjrViewPage(
                                          trainName: tName,
                                          trainNumber: tNum,
                                          tjrFileName: train.tjrFileName ?? '',
                                        ),
                                      ),
                                    ).then((_) => _loadTrains());
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              "Autor: Matěj — Verze: ${_appVersion.isNotEmpty ? _appVersion : 'Načítám...'}",
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}