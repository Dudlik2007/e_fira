import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'report_page.dart';
import 'report_data.dart';
import 'storage_service.dart';

class TrainSelectionPage extends StatefulWidget {
  const TrainSelectionPage({super.key});

  @override
  State<TrainSelectionPage> createState() => _TrainSelectionPageState();
}

class _TrainSelectionPageState extends State<TrainSelectionPage> {
  List<ReportData> trains = [
    ReportData(
      trainName: "Os10542",
      trainNumber: "10542",
      maxSpeed: "80",
      trainLength: "53",
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

  Future<void> _exportTrains() async {
    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Uložit vlaky jako CSV',
      fileName: 'trains_export.csv',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (outputPath != null) {
      final csvPath =
      await StorageService.exportTrainsToCsv(trains, filename: outputPath);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exportováno do:\n$csvPath")),
      );
    }
  }

  Future<void> _importTrains() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Vyber CSV soubor vlaků',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final imported = await StorageService.importTrainsFromCsv(path);
      if (imported.isNotEmpty) {
        setState(() {
          trains = imported;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vlaky byly importovány")),
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
        title: const Text(
          "Výběr vlaku",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.white),
            tooltip: "Exportovat vlaky",
            onPressed: _exportTrains,
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            tooltip: "Importovat vlaky",
            onPressed: _importTrains,
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "E-Fíra v0.5.1 Vytvořil: miniBrzda",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
