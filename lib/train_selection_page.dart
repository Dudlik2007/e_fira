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
  String _appVersion = "";

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
    setState(() {
      trains = loaded.isNotEmpty ? loaded : _demoTrains();
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
        jzbLocation: "",
        jzbPerformedBy: "",
        nbuStatus: "NBÜ",
        topSpeedAllowed: "80",
        doorControlStatus: "TB 0",
        powerSupplyStatus: "---",
        highSpeedCarsStatus: "ANO",
      ),
    ];
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
      final imported = await StorageService.importFromFile(result.files.single.path!);
      if (imported.isNotEmpty) {
        setState(() {
          trains = imported;
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
        title: Text("Výběr vlaku:"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _importTrains,
          ),
          if (Platform.isWindows || Platform.isLinux)
            IconButton(
              icon: const Icon(Icons.upload_file),
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
          Expanded(
            child: ListView.builder(
              itemCount: trains.length,
              itemBuilder: (context, index) {
                final train = trains[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      "${train.trainName} (${train.trainNumber})",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Rychlost: ${train.maxSpeed} km/h",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
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
