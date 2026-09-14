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
  late List<ReportData> _filteredTrains;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trains = List.from(widget.trains);
    _filteredTrains = List.from(_trains);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTrains = _trains.where((train) {
        final name = train.trainName.toLowerCase();
        final number = train.trainNumber.toLowerCase();
        return name.contains(query) || number.contains(query);
      }).toList();
    });
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
          train: _filteredTrains[index],
          onSave: (updated) async {
            final originalIndex = _trains.indexOf(_filteredTrains[index]);
            setState(() {
              _trains[originalIndex] = updated;
              _onSearchChanged();
            });
            await _saveTrains();
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
      final trainToRemove = _filteredTrains[index];
      setState(() {
        _trains.remove(trainToRemove);
        _onSearchChanged();
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
          onSave: (created) async {
            setState(() {
              _trains.add(created);
              _onSearchChanged();
            });
            await _saveTrains();
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: Colors.blueAccent,
                width: 1.2,
              ),
            ),
          ),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.blueAccent),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: _isSearching
                ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.blueAccent,
              decoration: const InputDecoration(
                hintText: "Hledat vlak...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            )
                : const Text(
              "Editor vlaků",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _searchController.clear();
                    }
                    _isSearching = !_isSearching;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: _filteredTrains.isEmpty
          ? const Center(
        child: Text(
          "Žádné vlaky k zobrazení",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _filteredTrains.length,
        itemBuilder: (context, index) {
          final train = _filteredTrains[index];
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
