import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift; // Přidáno pro Drift
import 'database/app_database.dart'; // Tvá databáze
import 'database/db_provider.dart';  // Zde máš late AppDatabase db;
import 'train_editor_page.dart';

class TrainEditListPage extends StatefulWidget {
  const TrainEditListPage({super.key}); // Již nepřijímá list zvenčí!

  @override
  State<TrainEditListPage> createState() => _TrainEditListPageState();
}

class _TrainEditListPageState extends State<TrainEditListPage> {
  List<Train> _trains = [];
  List<Train> _filteredTrains = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadTrains(); // Načteme rovnou z DB
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Načtení dat ze SQLite
  Future<void> _loadTrains() async {
    final loaded = await db.getAllTrains();
    setState(() {
      _trains = loaded;
      _onSearchChanged();
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTrains = _trains.where((train) {
        final name = (train.trainName ?? '').toLowerCase();
        final number = (train.trainNumber?.toString() ?? '').toLowerCase();
        return name.contains(query) || number.contains(query);
      }).toList();
    });
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editTrain(int index) async {
    final trainToEdit = _filteredTrains[index];
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainEditorPage(
          train: trainToEdit,
          onSave: (updatedCompanion) async {
            await db.updateTrain(updatedCompanion); // Uložíme do DB
            _showMessage("Změny byly uloženy");
            _loadTrains(); // Refresh seznamu
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
      await db.deleteTrain(trainToRemove); // Smažeme z DB
      _showMessage("Vlak byl smazán");
      _loadTrains(); // Refresh seznamu
    }
  }

  void _addTrain() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainEditorPage(
          train: null, // null znamená nový vlak
          onSave: (newCompanion) async {
            await db.insertTrain(newCompanion); // Vytvoříme v DB
            _showMessage("Nový vlak byl přidán");
            _loadTrains(); // Refresh seznamu
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
                
                final tName = train.trainName ?? "Neznámý";
                final tNum = train.trainNumber?.toString() ?? "???";
                final tSpeed = train.maxSpeed?.toString() ?? "N/A";

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
                      "$tName ($tNum)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Rychlost: $tSpeed km/h",
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