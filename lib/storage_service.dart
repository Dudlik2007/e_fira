// lib/storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:charset/charset.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'file_paths.dart'; // Tvůj existující soubor (předpokládám, že definuje getTjrDirectory)

class StorageService {
  
  //----------------------------------------------------------------------
  // 🔤 DEKÓDOVÁNÍ TEXTU (Pro eBulu / TJŘ)
  //----------------------------------------------------------------------
  static String decodeText(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return windows1250.decode(bytes);
    }
  }

  static List<int> encodeWindows1250(String text) => windows1250.encode(text);

  //----------------------------------------------------------------------
  // 💾 EXPORT / IMPORT LOKÁLNÍ SQLITE DATABÁZE
  //----------------------------------------------------------------------
  
  // Získáme přesnou cestu, kde je v zařízení uložená aktuální SQLite databáze
  static Future<File> getDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    // Musí přesně odpovídat názvu, který používáš v db_provider.dart (LazyDatabase)
    return File(p.join(dbFolder.path, 'db.sqlite')); 
  }

  // Export: Zkopíruje databázi do složky Stažené soubory (Downloads)
  static Future<String?> exportDatabase() async {
    try {
      final dbFile = await getDatabaseFile();
      if (!await dbFile.exists()) return null;

      // Získáme složku pro stažené soubory v závislosti na platformě
      Directory? downloadsDir;
      if (Platform.isWindows || Platform.isLinux) {
        final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
        if (home != null) {
          downloadsDir = Directory(p.join(home, 'Downloads'));
        }
      } else if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      }
      
      if (downloadsDir == null || !await downloadsDir.exists()) {
        return null; // Složka neexistuje
      }

      // Vytvoříme zálohu 
      final String fileName = 'efira_databaze_zaloha.sqlite';
      final String destPath = p.join(downloadsDir.path, fileName);
      
      await dbFile.copy(destPath);
      return destPath;
      
    } catch (e) {
      print("Chyba při exportu databáze: $e");
      return null;
    }
  }

  // Import: Nahradí současnou databázi za tu, kterou uživatel vybere
  static Future<bool> importDatabase(List<int> fileBytes) async {
    try {
      final dbFile = await getDatabaseFile();
      // Přepíšeme starý soubor novými daty
      await dbFile.writeAsBytes(fileBytes, flush: true);
      return true;
    } catch (e) {
      print("Chyba při importu databáze: $e");
      return false;
    }
  }


  //----------------------------------------------------------------------
  // 📕 ULOŽENÍ / ČTENÍ TJŘ TXT (ZŮSTÁVÁ BEZE ZMĚNY)
  //----------------------------------------------------------------------

  // 📁 Cesta pro TJŘ TXT
  static Future<String> _getTjrFolder() async {
    final dir = await getTjrDirectory();
    return dir.path;
  }

  /// Uloží TJŘ pro vlak (např. "10542.txt")
  static Future<void> saveTjrFile(
    String trainNumber,
    String content, {
    String? fileName,
  }) async {
    final folder = await _getTjrFolder();
    final safeFileName = (fileName?.trim().isNotEmpty ?? false)
        ? fileName!.trim().replaceAll(RegExp(r'[\\/]'), '_')
        : '$trainNumber.txt';
    final path = '$folder/$safeFileName';
    final file = File(path);
    await file.writeAsString(content, flush: true);
  }

  static Future<void> importTjrFile(String fileName, List<int> bytes) async {
    final safeFileName = fileName.trim();
    if (safeFileName.isEmpty) return;

    final content = decodeText(bytes);
    await saveTjrFile(
      safeFileName,
      content,
      fileName: safeFileName,
    );

    final baseName = safeFileName.split(RegExp(r'[\\/]')).last;
    final digits = RegExp(r'\d+').firstMatch(baseName)?.group(0);
    if (digits != null) {
      final number = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
      if (number.isNotEmpty && number != safeFileName) {
        await saveTjrFile(number, content, fileName: '$number.txt');
      }
    }
  }

  /// Vrátí cestu k TJŘ, pokud existuje
  static Future<String?> getTjrPath(String trainNumber) async {
    final folder = await _getTjrFolder();
    final path = '$folder/$trainNumber.txt';
    final file = File(path);
    if (await file.exists()) return path;
    return null;
  }

  /// Zda má vlak stažený TJŘ soubor
  static Future<bool> hasTjrFile(String trainNumber) async {
    final folder = await _getTjrFolder();
    final file = File('$folder/$trainNumber.txt');
    return file.exists();
  }

  /// Načte TJŘ obsah
  static Future<String?> loadTjrContent(String trainNumber) async {
    final path = await getTjrPath(trainNumber);
    if (path == null) return null;
    final bytes = await File(path).readAsBytes();
    return decodeText(bytes);
  }
}