import 'package:flutter/material.dart';
import 'dart:io';
import 'file_paths.dart';
import 'storage_service.dart';

class TrainTjrViewPage extends StatefulWidget {
  final String trainName;
  final String trainNumber;
  final String tjrFileName;

  const TrainTjrViewPage({
    super.key,
    required this.trainName,
    required this.trainNumber,
    required this.tjrFileName,
  });

  @override
  State<TrainTjrViewPage> createState() => _TrainTjrViewPageState();
}

class _TrainTjrViewPageState extends State<TrainTjrViewPage> {
  List<List<String>> _tableData = [];
  String _headerText = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTjrData();
  }

  Future<void> _loadTjrData() async {
    try {
      final dir = await getTjrDirectory();
      final fileNames = <String>{
        widget.tjrFileName.trim(),
        '${widget.trainNumber.trim()}.txt',
      }..removeWhere((name) => name == '.txt' || name.isEmpty);

      File? file;
      for (final fileName in fileNames) {
        final candidate = File('${dir.path}/$fileName');
        if (await candidate.exists()) {
          file = candidate;
          break;
        }
      }

      if (file == null) {
        setState(() {
          _isLoading = false;
          _error = 'TJŘ soubor nebyl nalezen. Zkontrolujte synchronizaci vlaku.';
        });
        return;
      }

      final raw = StorageService.decodeText(await file.readAsBytes());

      final lines = raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      int tableStart = lines.indexWhere((l) => RegExp(r'\d').hasMatch(l));
      if (tableStart == -1) tableStart = 0;

      _headerText = lines.take(tableStart).join('\n');
      final tableLines = lines.skip(tableStart).toList();

      // Detekce formátu podle přítomnosti znaku | na prvním řádku
      bool isPipeFormat = tableLines.isNotEmpty && tableLines.first.contains('|');

      _tableData = tableLines.map((line) {
        List<String> cells;
        if (isPipeFormat) {
          cells = line.split('|').map((p) => p.trim()).toList();
          // Zabrání vytvoření prázdného sloupce kvůli koncovému |
          if (cells.isNotEmpty && cells.last.isEmpty) {
            cells.removeLast();
          }
        } else {
          // Oddělení tabulátorem nebo vícenásobnými mezerami
          cells = line.split(RegExp(r'\t+|\s{2,}'))
              .map((p) => p.trim())
              .where((p) => p.isNotEmpty)
              .toList();
        }
        return cells;
      }).toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Chyba při načítání TJŘ: $e';
      });
    }
  }

  // Pomocná metoda pro zjištění max. počtu sloupců napříč všemi řádky
  int get _maxColumns {
    if (_tableData.isEmpty) return 0;
    return _tableData.fold(0, (max, row) => row.length > max ? row.length : max);
  }

  @override
  Widget build(BuildContext context) {
    final columnCount = _maxColumns;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('TJŘ – ${widget.trainName}'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vykreslení hlavičky dokumentu nad tabulkou
            if (_headerText.isNotEmpty) ...[
              Text(
                _headerText,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              // Vertikální + horizontální scroll pro dlouhé tratě
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    dataTextStyle: const TextStyle(
                        color: Colors.white, fontFamily: 'monospace'),
                    headingRowColor: WidgetStateProperty.all(Colors.grey.shade800),
                    dataRowColor: WidgetStateProperty.all(Colors.grey.shade900),
                    border: TableBorder.all(color: Colors.grey.shade700),
                    columns: _buildColumns(columnCount),
                    rows: _buildRows(columnCount),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(int maxColumns) {
    if (maxColumns == 0) return [];
    
    return List.generate(maxColumns, (index) {
      String colName = index == 0 ? 'Stanice' : (index == 1 ? 'Čas/Vzd.' : 'Údaj ${index + 1}');
      return DataColumn(label: Text(colName));
    });
  }

  List<DataRow> _buildRows(int maxColumns) {
    if (_tableData.isEmpty) return [];
    
    return _tableData.map((row) {
      final safeRow = List<String>.from(row);
      // Pokud je řádek kratší, doplní se pomlčky, aby DataTable nespadl
      while (safeRow.length < maxColumns) {
        safeRow.add('-');
      }
      final finalRow = safeRow.take(maxColumns).toList();

      return DataRow(
        cells: finalRow.map((c) => DataCell(Text(c))).toList(),
      );
    }).toList();
  }
}