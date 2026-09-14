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
  static const String _webSourceFileName = 'web_sync.csv';

  // 📁 Cesta do interní složky
  static Future<Directory> _getBaseDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // 📁 Cesta k CSV databázi vlaků
  static Future<String> _getCsvPath() async {
    final dir = await _getBaseDirectory();
    return '${dir.path}/$_localFileName';
  }

  static Future<Directory> _getTrainSourcesDirectory() async {
    final dir = Directory('${(await _getBaseDirectory()).path}/train_sources');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
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

  static Future<void> _saveTrainsFile(
      File file, List<ReportData> trains) async {
    final rows = <List<dynamic>>[ReportData.csvHeader()];
    rows.addAll(trains.map((train) => train.toCsvRow()));
    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }

  static Future<List<ReportData>> loadTrains() async {
    final files = <File>[File(await _getCsvPath())];
    final sourcesDirectory = await _getTrainSourcesDirectory();
    final sourceFiles = await sourcesDirectory
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.csv'))
        .map((entity) => File(entity.path))
        .toList();
    sourceFiles.sort((a, b) => a.path.compareTo(b.path));
    files.addAll(sourceFiles);

    final trains = <ReportData>[];
    for (final file in files) {
      if (!await file.exists()) continue;
      final content = decodeText(await file.readAsBytes());
      final rows = const CsvToListConverter(eol: '\n').convert(content);
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i].map((e) => e.toString()).toList();
        trains.add(ReportData.fromCsvRow(row));
      }
    }
    return trains;
  }

  static Future<void> saveWebTrains(List<ReportData> trains) async {
    final directory = await _getTrainSourcesDirectory();
    await _saveTrainsFile(
      File('${directory.path}/$_webSourceFileName'),
      trains,
    );
  }

  static Future<void> saveImportedTrains(
      List<ReportData> trains, {
      String? sourceName,
      }) async {
    final directory = await _getTrainSourcesDirectory();
    final safeSourceName = sourceName == null || sourceName.trim().isEmpty
        ? 'import_${DateTime.now().microsecondsSinceEpoch}.csv'
        : sourceName.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    final fileName = 'import_$safeSourceName';
    await _saveTrainsFile(File('${directory.path}/$fileName'), trains);
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
