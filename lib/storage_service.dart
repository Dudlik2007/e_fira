import 'dart:io';
import 'package:csv/csv.dart';
import 'report_data.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  /// Export vlaků do CSV.
  /// Pokud je [outputPath] null, uloží se do app dokumentů jako [filename].
  static Future<String> exportTrainsToCsv(
      List<ReportData> trains, {
        String filename = 'trains_export.csv',
        String? outputPath,
      }) async {
    final header = ReportData.csvHeader();
    final rows = <List<dynamic>>[header];
    for (final t in trains) {
      rows.add(t.toCsvRow());
    }
    final csv = const ListToCsvConverter().convert(rows);

    final file = outputPath != null
        ? File(outputPath)
        : File('${(await getApplicationDocumentsDirectory()).path}/$filename');

    await file.writeAsString(csv);
    return file.path;
  }

  /// Import vlaků z CSV.
  static Future<List<ReportData>> importTrainsFromCsv(String path) async {
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
}
