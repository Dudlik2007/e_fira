import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'report_data.dart';

class StorageService {
  static const String _localFileName = 'trains_data.csv';

  static Future<String> _getLocalPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$_localFileName';
  }

  static Future<void> saveTrains(List<ReportData> trains) async {
    final header = ReportData.csvHeader();
    final rows = <List<dynamic>>[header];
    for (final t in trains) {
      rows.add(t.toCsvRow());
    }
    final csv = const ListToCsvConverter().convert(rows);

    final path = await _getLocalPath();
    final file = File(path);
    await file.writeAsString(csv);
  }

  static Future<List<ReportData>> loadTrains() async {
    final path = await _getLocalPath();
    final file = File(path);
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

  /// Import CSV souboru z libovolné cesty a uložení do interní databáze
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

    // uložíme do interního CSV, aby se zachovalo i pro příště
    await saveTrains(trains);

    return trains;
  }
}
