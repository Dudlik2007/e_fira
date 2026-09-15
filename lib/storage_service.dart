import 'dart:convert';
import 'dart:io';
import 'package:charset/charset.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'report_data.dart';
import 'file_paths.dart';

class StorageService {
  static String decodeText(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return windows1250.decode(bytes);
    }
  }

  static List<int> encodeWindows1250(String text) => windows1250.encode(text);
  
  // 📁 Používáme POUZE JEDEN hlavní soubor
  static const String _localFileName = 'trains_data.csv';

  // 📁 Cesta do interní složky
  static Future<Directory> _getBaseDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // 📁 Cesta k hlavní (jediné) CSV databázi vlaků
  static Future<String> _getCsvPath() async {
    final dir = await _getBaseDirectory();
    return '${dir.path}/$_localFileName';
  }

  // 📁 Cesta pro TJŘ TXT
  static Future<String> _getTjrFolder() async {
    // Volá se centralizovaná funkce, aby obě platformy měly shodnou cestu
    final dir = await getTjrDirectory();
    return dir.path;
  }

  //----------------------------------------------------------------------
  // 🔽 ULOŽENÍ & NAČTENÍ CSV VLAKŮ (JEDEN SOUBOR)
  //----------------------------------------------------------------------

  /// Natvrdo přepíše hlavní soubor seznamem vlaků (používá se po mergování nebo při úpravách)
  static Future<void> saveTrains(List<ReportData> trains) async {
    final header = ReportData.csvHeader();
    final rows = <List<dynamic>>[header];

    for (final t in trains) {
      rows.add(t.toCsvRow());
    }

    final csv = const ListToCsvConverter().convert(rows);
    final file = File(await _getCsvPath());
    await file.writeAsString(csv);
  }

  /// Načte všechny vlaky pouze z jednoho hlavního CSV souboru
  static Future<List<ReportData>> loadTrains() async {
    final file = File(await _getCsvPath());
    
    if (!await file.exists()) {
      return [];
    }

    final trains = <ReportData>[];
    try {
      final content = decodeText(await file.readAsBytes());
      final rows = const CsvToListConverter(eol: '\n').convert(content);
      
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i].map((e) => e.toString()).toList();
        trains.add(ReportData.fromCsvRow(row));
      }
    } catch (e) {
      print("Chyba při načítání vlaků: $e");
    }
    
    return trains;
  }

  /// ⚙️ MERGOVÁNÍ: Vezme nové vlaky, porovná je s existujícími a sloučí je dohromady.
  /// Nedělá duplikáty, ale aktualizuje data.
  static Future<void> saveAndMergeTrains(List<ReportData> newTrains) async {
    // 1. Načteme stávající data
    List<ReportData> existingTrains = await loadTrains();

    // 2. Projdeme nově importované vlaky
    for (var newTrain in newTrains) {
      // Zjistíme, jestli vlak už existuje (shoda čísla a případně názvu)
      int existingIndex = existingTrains.indexWhere((t) => 
          t.trainNumber == newTrain.trainNumber && 
          t.trainName == newTrain.trainName);

      if (existingIndex != -1) {
        // Vlak už existuje -> AKTUALIZUJEME starý záznam novým
        existingTrains[existingIndex] = newTrain;
      } else {
        // Vlak ještě neexistuje -> PŘIDÁME ho na konec seznamu
        existingTrains.add(newTrain);
      }
    }

    // 3. Vše uložíme zpět do jednoho souboru (přepíšeme starý)
    await saveTrains(existingTrains);
  }

  /// Ukládání z webu - nyní pouze předá vlaky k mergování
  static Future<void> saveWebTrains(List<ReportData> trains) async {
    await saveAndMergeTrains(trains);
  }

  /// Ukládání z lokálního importu - nyní pouze předá vlaky k mergování
  static Future<void> saveImportedTrains(
    List<ReportData> trains, {
    String? sourceName,
  }) async {
    await saveAndMergeTrains(trains);
  }

  static Future<List<ReportData>> _parseCsvBytes(List<int> bytes) async {
    final content = decodeText(bytes);
    final rows = const CsvToListConverter(eol: '\n').convert(content);

    final trains = <ReportData>[];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i].map((e) => e.toString()).toList();
      trains.add(ReportData.fromCsvRow(row));
    }
    return trains;
  }

  //----------------------------------------------------------------------
  // 📤 EXPORT / 📥 IMPORT CSV
  //----------------------------------------------------------------------

  static Future<String> exportToDownloads(List<ReportData> trains) async {
    final header = ReportData.csvHeader();
    final rows = <List<dynamic>>[header];
    for (final t in trains) {
      rows.add(t.toCsvRow());
    }
    final csv = const ListToCsvConverter().convert(rows);

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final path = '${dir.path}/trains_export.csv';
    final file = File(path);
    await file.writeAsString(csv);
    return path;
  }

  static Future<List<ReportData>> importFromFile(String path) async {
    final file = File(path);
    if (!await file.exists()) return [];

    return importFromBytes(await file.readAsBytes());
  }

  static Future<List<ReportData>> importFromBytes(
    List<int> bytes, {
    String? sourceName,
  }) async {
    final trains = await _parseCsvBytes(bytes);
    
    // Zde probíhá sloučení do hlavního souboru
    await saveImportedTrains(trains, sourceName: sourceName);
    
    return trains;
  }

  //----------------------------------------------------------------------
  // 📕 ULOŽENÍ / ČTENÍ TJŘ TXT
  //----------------------------------------------------------------------

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