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
  bool _isPipeFormat = false;
  List<TjrRowData> _tjrData = [];
  List<List<String>> _pipeData = [];
  int _pipeMaxCols = 0;

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
      String fileName = widget.tjrFileName.trim();
      if (!fileName.toLowerCase().endsWith('.txt')) {
        fileName += '.txt';
      }

      final file = File('${dir.path}/$fileName');
      if (!(await file.exists())) {
        setState(() {
          _isLoading = false;
          _error = 'TJŘ soubor nebyl nalezen.\n\nHledaná cesta:\n${file.path}';
        });
        return;
      }

      final raw = StorageService.decodeText(await file.readAsBytes());
      final lines = raw.split('\n').map((e) => e.trimRight()).where((e) => e.isNotEmpty).toList();
      
      int tableStart = lines.indexWhere((l) => RegExp(r'\d').hasMatch(l));
      if (tableStart == -1) tableStart = 0;

      _headerText = lines.take(tableStart).join('\n');
      final tableLines = lines.skip(tableStart).toList();

      _isPipeFormat = tableLines.any((line) => line.contains('|'));

      if (_isPipeFormat) {
        // Zpracování 363.txt
        _pipeData = tableLines.map((line) {
          List<String> cells = line.split('|').map((p) => p.trim()).toList();
          if (cells.isNotEmpty && cells.last.isEmpty) cells.removeLast();
          return cells;
        }).toList();
        _pipeMaxCols = _pipeData.fold(0, (max, row) => row.length > max ? row.length : max);
        
      } else {
        // Zpracování 10542.txt (Rozpoznání příjezdů, odjezdů a nulových pobytů)
        List<TjrRowData> parsedRows = [];
        for (String line in tableLines) {
          List<String> cells = line
              .split(RegExp(r'\t+|\s{2,}'))
              .map((p) => p.trim())
              .where((p) => p.isNotEmpty)
              .toList();

          if (cells.isEmpty) continue;

          String station = cells[0];
          String time = '';
          String note = '';

          for (int i = 1; i < cells.length; i++) {
            if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(cells[i])) {
              time = cells[i];
            } else {
              note = cells[i];
            }
          }

          if (parsedRows.isNotEmpty && parsedRows.last.station == station) {
            // Víceřádková stanice - vložíme odjezdový čas (přičemž předchozí už je příjezd)
            parsedRows.last.departure = time;
            if (note.isNotEmpty) parsedRows.last.note = note;
          } else {
            // Nová stanice. Pokud má jen 1 čas, je to příjezd i odjezd zároveň (pobyt 0)
            parsedRows.add(TjrRowData(
              station: station,
              // Výchozí stanice nemá příjezd
              arrival: parsedRows.isEmpty ? '' : time, 
              departure: time,
              note: note,
            ));
          }
        }
        
        // Cílová stanice (poslední) nemá odjezd
        if (parsedRows.isNotEmpty) {
          parsedRows.last.departure = '';
        }
        
        _tjrData = parsedRows;
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Chyba při načítání TJŘ: $e';
      });
    }
  }

  int _diffMinutes(String t1, String t2) {
    if (t1.isEmpty || t2.isEmpty) return 0;
    try {
      var p1 = t1.split(':');
      var p2 = t2.split(':');
      int m1 = int.parse(p1[0]) * 60 + int.parse(p1[1]);
      int m2 = int.parse(p2[0]) * 60 + int.parse(p2[1]);
      if (m2 < m1) m2 += 24 * 60;
      return m2 - m1;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aplikace tmavého režimu
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        title: Text('TJŘ – ${widget.trainName}'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center))
              : _buildContent(),
    );
  }

Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              // Zajistí, že obsah bude mít minimálně šířku obrazovky
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // Zarovnání všeho (hlavičky i tabulky) na střed
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    if (_headerText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _headerText, 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center, // Vycentrování textu hlavičky
                        ),
                      ),
                    _isPipeFormat ? _buildPipeTable() : _buildTjrTable(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  // --- STANDARDNÍ TABULKA (10542.txt) ---
  Widget _buildTjrTable() {
    // Sledování hodin odděleně pro sl. 5 (příjezd) a sl. 7 (odjezd)
    String lastArrHour = '';
    String lastDepHour = '';
    String lastDeparture = '';
    
    List<TableRow> rows = [];
    
    rows.add(TableRow(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.grey.shade700))),
      children: [
        _buildHeaderCell('1'), _buildHeaderCell('2'), _buildHeaderCell('3'),
        _buildHeaderCell('5'), _buildHeaderCell('6'), _buildHeaderCell('7'),
        _buildHeaderCell('8a'), _buildHeaderCell('8'),
      ],
    ));

    for (var row in _tjrData) {
      String travelTime = '';
      String waitTime = '';

      // Jízdní doba (rozdíl mezi odjezdem z minulé stanice a příjezdem sem)
      if (lastDeparture.isNotEmpty && row.arrival.isNotEmpty) {
        int diff = _diffMinutes(lastDeparture, row.arrival);
        if (diff > 0) travelTime = diff.toString();
      } else if (lastDeparture.isNotEmpty && row.departure.isNotEmpty && row.arrival.isEmpty) {
        int diff = _diffMinutes(lastDeparture, row.departure);
        if (diff > 0) travelTime = diff.toString();
      }

      // Doba pobytu (0 vypíše automaticky, pokud příjezd == odjezd)
      if (row.arrival.isNotEmpty && row.departure.isNotEmpty) {
        waitTime = _diffMinutes(row.arrival, row.departure).toString();
      }

      // Volání nezávislých hodin pro Příjezd a Odjezd
      Widget arrWidget = _formatTime(row.arrival, lastArrHour, (newHour) => lastArrHour = newHour);
      Widget depWidget = _formatTime(row.departure, lastDepHour, (newHour) => lastDepHour = newHour);

      if (row.departure.isNotEmpty) {
        lastDeparture = row.departure;
      } else if (row.arrival.isNotEmpty) {
        lastDeparture = row.arrival;
      }

      rows.add(TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Text(row.station, style: const TextStyle(fontSize: 13, color: Colors.white)),
          ),
          const SizedBox(), // Zrušeno "x" ve druhém sloupci
          _buildCenterCell(travelTime),
          arrWidget,
          _buildCenterCell(waitTime),
          depWidget,
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Text(row.note, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ),
          const SizedBox(), // Sloupec 8 prázdný
        ],
      ));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 3, color: Colors.grey.shade700), 
          bottom: BorderSide(width: 3, color: Colors.grey.shade700)
        )
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(220), 1: FixedColumnWidth(25), 2: FixedColumnWidth(30),
          3: FixedColumnWidth(55), 4: FixedColumnWidth(30), 5: FixedColumnWidth(55),
          6: FixedColumnWidth(65), 7: FixedColumnWidth(40),
        },
        border: TableBorder(verticalInside: BorderSide(color: Colors.grey.shade700, width: 1.5)),
        children: rows,
      ),
    );
  }

  // --- ZÁLOŽNÍ TABULKA (363.txt) ---
  Widget _buildPipeTable() {
    if (_pipeMaxCols == 0) return const SizedBox();
    List<TableRow> rows = [];
    
    rows.add(TableRow(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.grey.shade700))),
      children: List.generate(_pipeMaxCols, (index) {
        String colName = index == 0 ? 'Stanice' : 'Údaj $index';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Text(
            colName,
            textAlign: index == 0 ? TextAlign.left : TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    ));

    for (var row in _pipeData) {
      List<Widget> cells = [];
      for (int i = 0; i < _pipeMaxCols; i++) {
        String val = i < row.length ? row[i] : '-';
        cells.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            val,
            textAlign: i == 0 ? TextAlign.left : TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ));
      }
      rows.add(TableRow(children: cells));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 3, color: Colors.grey.shade700), 
          bottom: BorderSide(width: 3, color: Colors.grey.shade700)
        )
      ),
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder(verticalInside: BorderSide(color: Colors.grey.shade700, width: 1.5)),
        children: rows,
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildCenterCell(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white)),
    );
  }

  Widget _formatTime(String timeStr, String currentLastHour, Function(String) updateLastHour) {
    if (timeStr.isEmpty) return const SizedBox();
    var parts = timeStr.split(':');
    if (parts.length != 2) return Text(timeStr, style: const TextStyle(color: Colors.white));
    
    String hour = int.parse(parts[0]).toString(); 
    String minute = parts[1];
    
    // Hodinu vypíšeme vždy, když je jiná než v předchozím řádku TÉHOŽ sloupce
    bool showHour = hour != currentLastHour;
    if (showHour) updateLastHour(hour);

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 15, 
            child: Text(
              showHour ? hour : '', 
              textAlign: TextAlign.right, 
              style: const TextStyle(fontSize: 13, color: Colors.white)
            )
          ),
          const SizedBox(width: 4),
          Text(minute, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}

class TjrRowData {
  String station;
  String arrival;
  String departure;
  String note;

  TjrRowData({
    required this.station,
    required this.arrival,
    required this.departure,
    required this.note,
  });
}