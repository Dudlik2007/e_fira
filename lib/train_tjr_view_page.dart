import 'package:flutter/material.dart';
import 'dart:io';
import 'file_paths.dart';

class TrainTjrViewPage extends StatefulWidget {
  final String trainName;
  final String tjrFileName;

  const TrainTjrViewPage({
    super.key,
    required this.trainName,
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
      final filePath = '${dir.path}/${widget.tjrFileName}';
      final file = File(filePath);

      if (!await file.exists()) {
        setState(() {
          _isLoading = false;
          _error = 'Soubor ${widget.tjrFileName} nebyl nalezen.';
        });
        return;
      }

      final raw = await file.readAsString();

      final lines = raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      int tableStart = lines.indexWhere((l) => RegExp(r'\d').hasMatch(l));
      if (tableStart == -1) tableStart = 0;

      _headerText = lines.take(tableStart).join('\n');
      final tableLines = lines.skip(tableStart).toList();

      _tableData = tableLines
          .map((line) => line.split(RegExp(r'\s{2,}')).map((p) => p.trim()).toList())
          .toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Chyba při načítání TJŘ: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            dataTextStyle: const TextStyle(
                color: Colors.white, fontFamily: 'monospace'),
            headingRowColor:
            WidgetStateProperty.all(Colors.grey.shade800),
            dataRowColor:
            WidgetStateProperty.all(Colors.grey.shade900),
            border: TableBorder.all(color: Colors.grey.shade700),
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    if (_tableData.isEmpty) return [];
    final header = _tableData.first;
    return header.map((c) => DataColumn(label: Text(c))).toList();
  }

  List<DataRow> _buildRows() {
    if (_tableData.length < 2) return [];
    return _tableData.skip(1).map((row) {
      return DataRow(cells: row.map((c) => DataCell(Text(c))).toList());
    }).toList();
  }
}
