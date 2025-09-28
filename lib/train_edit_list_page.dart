// lib/train_edit_list_page.dart
import 'package:flutter/material.dart';
import 'report_data.dart';
import 'storage_service.dart';
import 'train_editor_page.dart';

class TrainEditListPage extends StatefulWidget {
  final List<ReportData> trains;

  const TrainEditListPage({super.key, required this.trains});

  @override
  State<TrainEditListPage> createState() => _TrainEditListPageState();
}

class _TrainEditListPageState extends State<TrainEditListPage> {
  late List<ReportData> _trains;

  @override
  void initState() {
    super.initState();
    _trains = List.from(widget.trains);
  }

  Future<void> _saveTrains() async {
    await StorageService.saveTrains(_trains);
  }

  void _editTrain(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainEditorPage(
          train: _trains[index],
          onSave: (updated) {
            setState(() {
              _trains[index] = updated;
            });
            _saveTrains();
          },
        ),
      ),
    );
  }

  void _deleteTrain(int index) async {
    setState(() {
      _trains.removeAt(index);
    });
    await _saveTrains();
  }

  void _addTrain() async {
    final newTrain = ReportData(
      trainName: "Nový vlak",
      trainNumber: "",
      maxSpeed: "0",
      trainLength: "0",
      trainWheels: "",
      trainCars: 0,
      brakeTypeD: "0",
      brakeTypeK: "0",
      brakeMode: "",
      brakingModeP: "0",
      brakingModeR: "0",
      brakingModeRMg: "0",
      brakePercent: "0",
      brakingPercentageActual: "0",
      brakingPercentageRequired: "0",
      brakingPercentageMissing: "0",
      activeVehiclesCount: 0,
      transportVehiclesCount: 0,
      totalVehiclesCount: 0,
      activeVehiclesWeight: 0.0,
      transportVehiclesWeight: 0.0,
      totalVehiclesWeight: 0.0,
      departureStation: "",
      currentStation: "",
      destinationStation: "",
      uzbLocation: "",
      uzbPerformedBy: "",
      jzbLocation: "",
      jzbPerformedBy: "",
      nbuStatus: "",
      topSpeedAllowed: "",
      doorControlStatus: "",
      powerSupplyStatus: "",
      highSpeedCarsStatus: "",
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainEditorPage(
          train: newTrain,
          onSave: (created) {
            setState(() {
              _trains.add(created);
            });
            _saveTrains();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Editor vlaků"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Přidat vlak",
            onPressed: _addTrain,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _trains.length,
        itemBuilder: (context, index) {
          final train = _trains[index];
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
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _deleteTrain(index),
              ),
              onTap: () => _editTrain(index),
            ),
          );
        },
      ),
    );
  }
}
