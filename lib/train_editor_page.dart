import 'package:flutter/material.dart';
import 'report_data.dart';

class TrainEditorPage extends StatefulWidget {
  final ReportData train;
  final Future<void> Function(ReportData) onSave;

  const TrainEditorPage({
    super.key,
    required this.train,
    required this.onSave,
  });

  @override
  State<TrainEditorPage> createState() => _TrainEditorPageState();
}

class _TrainEditorPageState extends State<TrainEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late ReportData _edited;

  @override
  void initState() {
    super.initState();
    _edited = widget.train;
  }

  Future<void> _save() async {
    await widget.onSave(_edited);
    if (!mounted) return;
    Navigator.pop(context);
  }

  // Původní pole - upravené pro lepší flexibilitu v řádcích
  Widget _buildField({
    required String label,
    required String initial,
    bool isNumber = false,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        initialValue: initial,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          isDense: true, // Zmenší vnitřní odsazení, políčko nebude tak zbytečně vysoké
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none, // Vypadá čistěji bez vnější linky
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: onChanged,
      ),
    );
  }

  // Pomocný widget pro 2 políčka vedle sebe (ušetří spoustu místa)
  Widget _buildRow(Widget field1, Widget field2) {
    return Row(
      children: [
        Expanded(child: field1),
        const SizedBox(width: 8),
        Expanded(child: field2),
      ],
    );
  }

  // Pomocný widget pro zabalení sekce do Karty
  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      color: const Color(0xFF1A1A1A), // Lehce světlejší než pozadí aplikace
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.blueAccent, // Zvýrazníme nadpis sekce
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Úprava vlaku"),
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blueAccent),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            
            _buildSectionCard("Základní informace", [
              _buildField(
                label: "Název vlaku",
                initial: _edited.trainName,
                onChanged: (v) => _edited = _edited.copyWith(trainName: v),
              ),
              _buildRow(
                _buildField(
                  label: "Číslo vlaku",
                  initial: _edited.trainNumber,
                  onChanged: (v) => _edited = _edited.copyWith(trainNumber: v),
                ),
                _buildField(
                  label: "Max. rychlost",
                  initial: _edited.maxSpeed,
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(maxSpeed: v),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Délka (m)",
                  initial: _edited.trainLength,
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(trainLength: v),
                ),
                _buildField(
                  label: "Počet vozů",
                  initial: _edited.trainCars.toString(),
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(trainCars: int.tryParse(v) ?? 0),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Počet náprav",
                  initial: _edited.trainWheels,
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(trainWheels: v),
                ),
                _buildField(
                  label: "TJŘ soubor",
                  initial: _edited.tjrFileName ?? '',
                  onChanged: (v) => _edited = _edited.copyWith(tjrFileName: v),
                ),
              ),
            ]),

            _buildSectionCard("Brzdy", [
              _buildRow(
                _buildField(
                  label: "Typ brzdy D",
                  initial: _edited.brakeTypeD,
                  onChanged: (v) => _edited = _edited.copyWith(brakeTypeD: v),
                ),
                _buildField(
                  label: "Typ brzdy K",
                  initial: _edited.brakeTypeK,
                  onChanged: (v) => _edited = _edited.copyWith(brakeTypeK: v),
                ),
              ),
              _buildField(
                label: "Režim brzdy (P; R; R+Mg)",
                initial: _edited.brakeMode,
                onChanged: (v) => _edited = _edited.copyWith(brakeMode: v),
              ),
              _buildRow(
                _buildField(
                  label: "Režim P (počet)",
                  initial: _edited.brakingModeP,
                  onChanged: (v) => _edited = _edited.copyWith(brakingModeP: v),
                ),
                _buildField(
                  label: "Režim R (počet)",
                  initial: _edited.brakingModeR,
                  onChanged: (v) => _edited = _edited.copyWith(brakingModeR: v),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Režim R+Mg",
                  initial: _edited.brakingModeRMg,
                  onChanged: (v) => _edited = _edited.copyWith(brakingModeRMg: v),
                ),
                _buildField(
                  label: "Brzdicí %",
                  initial: _edited.brakePercent,
                  onChanged: (v) => _edited = _edited.copyWith(brakePercent: v),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Skut. brzd. %",
                  initial: _edited.brakingPercentageActual,
                  onChanged: (v) => _edited = _edited.copyWith(brakingPercentageActual: v),
                ),
                _buildField(
                  label: "Pož. brzd. %",
                  initial: _edited.brakingPercentageRequired,
                  onChanged: (v) => _edited = _edited.copyWith(brakingPercentageRequired: v),
                ),
              ),
              _buildField(
                label: "Chybějící brzd. %",
                initial: _edited.brakingPercentageMissing,
                onChanged: (v) => _edited = _edited.copyWith(brakingPercentageMissing: v),
              ),
            ]),

            _buildSectionCard("Vozidla a Hmotnosti", [
              // Zde by šlo udělat tabulku, ale pro jednoduchost dáme vedle sebe Počet / Hmotnost
              _buildRow(
                _buildField(
                  label: "Činná vozidla",
                  initial: _edited.activeVehiclesCount.toString(),
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(activeVehiclesCount: int.tryParse(v) ?? 0),
                ),
                _buildField(
                  label: "Hmotnost činných (t)",
                  initial: _edited.activeVehiclesWeight.toString(),
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(activeVehiclesWeight: double.tryParse(v) ?? 0.0),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Doprovod. vozidla",
                  initial: _edited.transportVehiclesCount.toString(),
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(transportVehiclesCount: int.tryParse(v) ?? 0),
                ),
                _buildField(
                  label: "Hmotnost doprov. (t)",
                  initial: _edited.transportVehiclesWeight.toString(),
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(transportVehiclesWeight: double.tryParse(v) ?? 0.0),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Vozidla celkem",
                  initial: _edited.totalVehiclesCount.toString(),
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(totalVehiclesCount: int.tryParse(v) ?? 0),
                ),
                _buildField(
                  label: "Hmotnost celkem (t)",
                  initial: _edited.totalVehiclesWeight.toString(),
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(totalVehiclesWeight: double.tryParse(v) ?? 0.0),
                ),
              ),
            ]),

            _buildSectionCard("Stanice", [
              _buildField(
                label: "Výchozí stanice",
                initial: _edited.departureStation,
                onChanged: (v) => _edited = _edited.copyWith(departureStation: v),
              ),
              _buildField(
                label: "Aktuální stanice",
                initial: _edited.currentStation,
                onChanged: (v) => _edited = _edited.copyWith(currentStation: v),
              ),
              _buildField(
                label: "Cílová stanice",
                initial: _edited.destinationStation,
                onChanged: (v) => _edited = _edited.copyWith(destinationStation: v),
              ),
            ]),

            _buildSectionCard("UZB / JZB", [
              _buildRow(
                _buildField(
                  label: "Místo UZB",
                  initial: _edited.uzbLocation,
                  onChanged: (v) => _edited = _edited.copyWith(uzbLocation: v),
                ),
                _buildField(
                  label: "Provedl UZB",
                  initial: _edited.uzbPerformedBy,
                  onChanged: (v) => _edited = _edited.copyWith(uzbPerformedBy: v),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Místo JZB",
                  initial: _edited.jzbLocation,
                  onChanged: (v) => _edited = _edited.copyWith(jzbLocation: v),
                ),
                _buildField(
                  label: "Provedl JZB",
                  initial: _edited.jzbPerformedBy,
                  onChanged: (v) => _edited = _edited.copyWith(jzbPerformedBy: v),
                ),
              ),
            ]),

            _buildSectionCard("Systémy", [
              _buildRow(
                _buildField(
                  label: "NBÜ stav",
                  initial: _edited.nbuStatus,
                  onChanged: (v) => _edited = _edited.copyWith(nbuStatus: v),
                ),
                _buildField(
                  label: "Max. povolená rych.",
                  initial: _edited.topSpeedAllowed,
                  isNumber: true,
                  onChanged: (v) => _edited = _edited.copyWith(topSpeedAllowed: v),
                ),
              ),
              _buildRow(
                _buildField(
                  label: "Ovládání dveří",
                  initial: _edited.doorControlStatus,
                  onChanged: (v) => _edited = _edited.copyWith(doorControlStatus: v),
                ),
                _buildField(
                  label: "Napájení",
                  initial: _edited.powerSupplyStatus,
                  onChanged: (v) => _edited = _edited.copyWith(powerSupplyStatus: v),
                ),
              ),
              _buildField(
                label: "Horní rychlostníky",
                initial: _edited.highSpeedCarsStatus,
                onChanged: (v) => _edited = _edited.copyWith(highSpeedCarsStatus: v),
              ),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}