import 'dart:convert';
import 'dart:io';
import 'package:charset/charset.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'report_data.dart';

class StorageService {
  static String decodeText(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return windows1250.decode(bytes);
    }
  }

  static List<int> encodeWindows1250(String text) => windows1250.encode(text);
  static const String _localFileName = 'trains_data.csv';

  // 📁 Cesta do interní složky
  static Future<Directory> _getBaseDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // 📁 Cesta k CSV databázi vlaků
  static Future<String> _getCsvPath() async {
    final dir = await _getBaseDirectory();
    return '${dir.path}/$_localFileName';
  }

  // 📁 Cesta pro TJŘ TXT
  static Future<String> _getTjrFolder() async {
    final dir = await _getBaseDirectory();
    final path = '${dir.path}/Brzdenka/TJR';
    final folder = Directory(path);
    if (!await folder.exists()) await folder.create(recursive: true);
    return path;
  }

  //----------------------------------------------------------------------
  // 🔽 ULOŽENÍ & NAČTENÍ CSV VLAKŮ
  //----------------------------------------------------------------------

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

  static Future<List<ReportData>> loadTrains() async {
    final file = File(await _getCsvPath());
    if (!await file.exists()) return [];

    final content = await file.readAsString();
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

    final content = await file.readAsString();
    final rows = const CsvToListConverter(eol: '\n').convert(content);

    final trains = <ReportData>[];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i].map((e) => e.toString()).toList();
      trains.add(ReportData.fromCsvRow(row));
    }

    await saveTrains(trains);
    return trains;
  }

  //----------------------------------------------------------------------
  // 📕 ULOŽENÍ / ČTENÍ TJŘ TXT
  //----------------------------------------------------------------------

  /// Uloží TJŘ pro vlak (např. "10542.txt")
  static Future<void> saveTjrFile(String trainNumber, String content) async {
    final folder = await _getTjrFolder();
    final path = '$folder/$trainNumber.txt';
    final file = File(path);
    await file.writeAsString(content, flush: true);
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
