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

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
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
            _showMessage("Změny byly uloženy");
          },
        ),
      ),
    );
  }

  void _deleteTrain(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Smazat vlak?"),
        content: const Text("Opravdu chcete tento vlak odstranit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Zrušit"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Smazat",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _trains.removeAt(index);
      });
      await _saveTrains();
      _showMessage("Vlak byl smazán");
    }
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
            _showMessage("Nový vlak byl přidán");
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
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
      ),
      body: _trains.isEmpty
          ? const Center(
        child: Text(
          "Žádné vlaky k zobrazení",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _trains.length,
        itemBuilder: (context, index) {
          final train = _trains[index];
          return Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              title: Text(
                "${train.trainName} (${train.trainNumber})",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addTrain,
        tooltip: 'Přidat vlak',
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
