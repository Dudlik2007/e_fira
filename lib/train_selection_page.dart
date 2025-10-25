import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'report_page.dart';
import 'report_data.dart';
import 'storage_service.dart';
import 'train_edit_list_page.dart';
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
    _loadTrains();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${info.version}+${info.buildNumber}";
    });
  }

  Future<void> _loadTrains() async {
    final loaded = await StorageService.loadTrains();
    final list = loaded.isNotEmpty ? loaded : _demoTrains();
    setState(() {
      trains = list;
      filteredTrains = list;
    });
  }

  List<ReportData> _demoTrains() {
    return [
      ReportData(
        trainName: "Os10542",
        trainNumber: "10542",
        maxSpeed: "80",
        trainLength: "54",
        trainWheels: "12n",
        trainCars: 3,
        brakeTypeD: "0",
        brakeTypeK: "0",
        brakeMode: "P",
        brakingModeP: "3",
        brakingModeR: "0",
        brakingModeRMg: "0",
        brakePercent: "90",
        brakingPercentageActual: "90",
        brakingPercentageRequired: "90",
        brakingPercentageMissing: "0",
        activeVehiclesCount: 1,
        transportVehiclesCount: 2,
        totalVehiclesCount: 3,
        activeVehiclesWeight: 71.0,
        transportVehiclesWeight: 68.0,
        totalVehiclesWeight: 139.0,
        departureStation: "Albrechtice nad Vltavou",
        currentStation: "Albrechtice nad Vltavou",
        destinationStation: "Štěchovice",
        uzbLocation: "Albrechtice nad Vltavou",
        uzbPerformedBy: "Vozmistr",
        nbuStatus: "NBÜ",
        topSpeedAllowed: "80",
        doorControlStatus: "TB 0",
        powerSupplyStatus: "---",
        highSpeedCarsStatus: "ANO", jzbLocation: '', jzbPerformedBy: '',
      ),
    ];
  }

  void _applyFilter(String query) {
    setState(() {
      _filter = query;
      filteredTrains = trains
          .where((t) =>
      t.trainName.toLowerCase().contains(query.toLowerCase()) ||
          t.trainNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
          filteredTrains = imported;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vlaky byly importovány a uloženy")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white, // ikony i text AppBaru budou světlé
        title: const Text("Výběr vlaku"),
        actions: [
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
                ).then((_) => _loadTrains());
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

          // 🧾 Seznam vlaků
          Expanded(
            child: ListView.builder(
              itemCount: filteredTrains.length,
              itemBuilder: (context, index) {
                final train = filteredTrains[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      "${train.trainName} (${train.trainNumber})",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Rychlost: ${train.maxSpeed} km/h",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportPage(data: train),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // 📦 Informace o verzi
          const SizedBox(height: 8),
          Center(
            child: Text(
              "Autor: Matěj — Verze: ${_appVersion.isNotEmpty ? _appVersion : 'Načítám...'}",
              style: const TextStyle(color: Colors.white60, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
