// file: C:/Users/admin/StudioProjects/e_fira/lib/train_selection_page.dart. 

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'report_page.dart';
import 'report_data.dart';
import 'storage_service.dart';
import 'train_edit_list_page.dart';
import 'train_tjr_view_page.dart';
import 'web_loader.dart'; // Ujisti se, že importuješ web_loader.dart
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

class TrainSelectionPage extends StatefulWidget {
  const TrainSelectionPage({super.key});

  @override
  State<TrainSelectionPage> createState() => _TrainSelectionPageState();
}

class _TrainSelectionPageState extends State<TrainSelectionPage> {
  List<ReportData> trains = [];
  List<ReportData> filteredTrains = [];
  String _appVersion = "";
  String _filter = "";

  @override
  void initState() {
    super.initState();
    _loadTrains(); // Načte vlaky při prvním spuštění
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${info.version}+${info.buildNumber}";
    });
  }

  /// Načítá vlaky ze StorageService a aktualizuje stav.
  /// Mělo by být voláno vždy, když chceme načíst aktuální data.
  Future<void> _loadTrains() async {
    final loaded = await StorageService.loadTrains();

    setState(() {
      trains = loaded;
      _applyFilter(_filter); // Znovu aplikuje filtr na nově načtená data
    });
  }

  void _applyFilter(String query) {
    setState(() {
      _filter = query;
      filteredTrains = trains.where((t) {
        return t.trainName.toLowerCase().contains(query.toLowerCase()) ||
            t.trainNumber.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _exportTrains() async {
    final path = await StorageService.exportToDownloads(trains);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exportováno do: $path")),
    );
  }

  Future<void> _importTrains() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Vyber CSV soubor vlaků',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      final imported =
      await StorageService.importFromFile(result.files.single.path!);

      if (imported.isNotEmpty) {
        setState(() {
          trains = imported;
          _applyFilter(_filter); // Znovu aplikujeme filtr na importovaná data
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vlaky byly importovány a uloženy")),
        );
      }
    }
  }

  // --- ZMĚNA JE POUZE ZDE ---
  Future<void> _navigateToWebLoader() async {
    // Používáme push, ale tentokrát čekáme na výsledek (Future<bool?>)
    final bool? shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const WebLoaderPage()),
    );

    // Pokud je výsledek 'true', znamená to, že došlo k úspěšné synchronizaci
    if (shouldRefresh == true) {
      // Znovu načti vlaky, aby se zobrazily nové/aktualizované údaje
      await _loadTrains();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vlaky byly aktualizovány z webu")),
        );
      }
    }
  }
  // --- KONEC ZMĚNY ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        title: const Text("Výběr vlaku"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            tooltip: "Nastavení a synchronizace webu",
            onPressed: _navigateToWebLoader, // Voláme novou metodu
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Importovat vlaky",
            onPressed: _importTrains,
          ),
          if (Platform.isWindows || Platform.isLinux)
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: "Exportovat vlaky",
              onPressed: _exportTrains,
            ),
          if (Platform.isWindows || Platform.isLinux)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editor vlaků",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainEditListPage(trains: trains),
                  ),
                ).then((_) => _loadTrains()); // Editor by také měl vyvolat znovunačtení
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Filtrovací pole
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Filtrovat podle názvu nebo čísla vlaku...",
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _applyFilter,
            ),
          ),

          Expanded(
            child: trains.isEmpty
                ? const Center(
              child: Text(
                "Nenalezeny žádné uložené vlaky",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: filteredTrains.length,
              itemBuilder: (context, index) {
                final train = filteredTrains[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      "${train.trainName} (${train.trainNumber})",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Rychlost: ${train.maxSpeed} km/h",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.table_chart,
                              color: Colors.lightBlueAccent),
                          tooltip: "Otevřít brzděnku",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportPage(data: train),
                              ),
                            ).then((_) => _loadTrains());
                          },
                        ),
                        if (train.trainNumber.trim().isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.description,
                                color: Colors.amberAccent),
                            tooltip: "Zobrazit jízdní řád (TJŘ)",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrainTjrViewPage(
                                    trainName: train.trainName,
                                    trainNumber: train.trainNumber,
                                    tjrFileName: train.tjrFileName ?? '',
                                  ),
                                ),
                              ).then((_) => _loadTrains());
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
          Center(
            child: Text(
              "Autor: Matěj — Verze: ${_appVersion.isNotEmpty ? _appVersion : 'Načítám...'}",
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}