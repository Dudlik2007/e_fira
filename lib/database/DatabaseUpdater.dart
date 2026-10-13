import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

// Ujisti se, že tyto cesty odpovídají tomu, kde soubory v projektu máš:
import 'app_database.dart';
import '../storage_service.dart';

class DatabaseUpdater {
  // Klíče, pod kterými budeme URL ukládat v SharedPreferences
  static const String _dbUrlKey = 'server_database_url';
  static const String _ebulaUrlKey = 'ebula_base_url';

  /// Uloží obě URL zadané uživatelem do paměti
  static Future<void> saveUrls(String dbUrl, String ebulaUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dbUrlKey, dbUrl.trim());
    await prefs.setString(_ebulaUrlKey, ebulaUrl.trim());
  }

  /// Hlavní synchronizace: Stáhne databázi a následně eBula soubory
  /// Vrací zprávu o úspěchu nebo chybovou zprávu.
  static Future<String> syncAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dbUrl = prefs.getString(_dbUrlKey) ?? '';
      final ebulaUrl = prefs.getString(_ebulaUrlKey) ?? '';
      
      // Kontrola, jestli uživatel URL vůbec zadal
      if (dbUrl.isEmpty || ebulaUrl.isEmpty) {
        return 'Není nastavena URL adresa serveru nebo eBuly. Přejděte do nastavení.';
      }

      print('Zahajuji stahování databáze z $dbUrl...');
      
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, 'databaze.sqlite');
      final file = File(dbPath);

      // ==========================================
      // 1. STAŽENÍ DATABÁZE
      // ==========================================
      final dbResponse = await http.get(Uri.parse(dbUrl)).timeout(const Duration(seconds: 15));

      if (dbResponse.statusCode == 200) {
        await file.writeAsBytes(dbResponse.bodyBytes, flush: true);
        print('Databáze byla úspěšně stažena a uložena.');
      } else {
        return 'Chyba při stahování databáze. Server vrátil kód: ${dbResponse.statusCode}';
      }

      // ==========================================
      // 2. NAČTENÍ VLAKŮ A STAŽENÍ EBULY
      // ==========================================
      print('Zahajuji stahování eBula souborů...');
      final tempDb = AppDatabase();
      final trains = await tempDb.getAllTrains(); // Vyčteme vlaky ze stažené DB
      
      int downloaded = 0;
      int failed = 0;
      
      final baseUri = Uri.parse(ebulaUrl.endsWith('/') ? ebulaUrl : '$ebulaUrl/');
      final client = http.Client();

      for (final train in trains) {
        // Pokud vlak nemá číslo, nemáme podle čeho eBulu pojmenovat
        if (train.trainNumber == null) continue;
        
        final numberStr = train.trainNumber.toString();
        
        String fileName = (train.tjrFileName != null && train.tjrFileName!.trim().isNotEmpty)
            ? train.tjrFileName!.trim()
            : '$numberStr.txt';

        if (!fileName.toLowerCase().endsWith('.txt')) {
          fileName = '$fileName.txt';
        }

        try {
          final uri = baseUri.resolve(fileName);
          final response = await client.get(uri).timeout(const Duration(seconds: 8));
          
          if (response.statusCode == 200) {
            // Používáme tvoji původní StorageService pro uložení eBuly
            final text = StorageService.decodeText(response.bodyBytes);
            await StorageService.saveTjrFile(numberStr, text, fileName: fileName);
            downloaded++;
          } else {
            failed++;
          }
        } catch (e) {
          failed++;
        }
      }
      
      client.close();
      await tempDb.close(); // Uvolníme SQLite z paměti

      return 'Úspěch: Databáze a $downloaded eBula souborů staženo. ($failed chyb)';

    } catch (e) {
      return 'Během stahování došlo k chybě: Zkontrolujte URL a připojení k internetu.';
    }
  }

  /// Zkontroluje, zda databáze v zařízení už existuje
  static Future<bool> doesDatabaseExistLocally() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'databaze.sqlite');
    return File(dbPath).exists();
  }
}