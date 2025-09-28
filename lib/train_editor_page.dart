import 'package:flutter/material.dart';
import 'report_data.dart';

class TrainEditorPage extends StatefulWidget {
  final ReportData train;
  final ValueChanged<ReportData> onSave;

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

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_edited);
      Navigator.pop(context);
    }
  }

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
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => (v == null || v.isEmpty) ? "Vyplň $label" : null,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Editor vlaku"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text("Základní informace",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            _buildField(
              label: "Název vlaku",
              initial: _edited.trainName,
              onChanged: (v) =>
              _edited = _edited.copyWith(trainName: v),
            ),
            _buildField(
              label: "Číslo vlaku",
              initial: _edited.trainNumber,
              isNumber: true,
              onChanged: (v) =>
              _edited = _edited.copyWith(trainNumber: v),
            ),
            _buildField(
              label: "Maximální rychlost",
              initial: _edited.maxSpeed,
              isNumber: true,
              onChanged: (v) =>
              _edited = _edited.copyWith(maxSpeed: v),
            ),
            _buildField(
              label: "Délka vlaku",
              initial: _edited.trainLength,
              isNumber: true,
              onChanged: (v) =>
              _edited = _edited.copyWith(trainLength: v),
            ),
            _buildField(
              label: "Počet vozů",
              initial: _edited.trainCars.toString(),
              isNumber: true,
              onChanged: (v) =>
              _edited = _edited.copyWith(trainCars: int.tryParse(v) ?? 0),
            ),
            _buildField(
              label: "Kola",
              initial: _edited.trainWheels,
              onChanged: (v) =>
              _edited = _edited.copyWith(trainWheels: v),
            ),

            const SizedBox(height: 12),
            const Text("Brzdy", style: TextStyle(color: Colors.white, fontSize: 18)),
            _buildField(
              label: "Typ brzdy D",
              initial: _edited.brakeTypeD,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakeTypeD: v),
            ),
            _buildField(
              label: "Typ brzdy K",
              initial: _edited.brakeTypeK,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakeTypeK: v),
            ),
            _buildField(
              label: "Režim brzdy",
              initial: _edited.brakeMode,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakeMode: v),
            ),
            _buildField(
              label: "Brzd. režim P",
              initial: _edited.brakingModeP,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakingModeP: v),
            ),
            _buildField(
              label: "Brzd. režim R",
              initial: _edited.brakingModeR,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakingModeR: v),
            ),
            _buildField(
              label: "Brzd. režim R+Mg",
              initial: _edited.brakingModeRMg,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakingModeRMg: v),
            ),
            _buildField(
              label: "Brzdicí %",
              initial: _edited.brakePercent,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakePercent: v),
            ),
            _buildField(
              label: "Skutečné % brzdění",
              initial: _edited.brakingPercentageActual,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakingPercentageActual: v),
            ),
            _buildField(
              label: "Požadované % brzdění",
              initial: _edited.brakingPercentageRequired,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakingPercentageRequired: v),
            ),
            _buildField(
              label: "Chybějící % brzdění",
              initial: _edited.brakingPercentageMissing,
              onChanged: (v) =>
              _edited = _edited.copyWith(brakingPercentageMissing: v),
            ),

            const SizedBox(height: 12),
            const Text("Stanice", style: TextStyle(color: Colors.white, fontSize: 18)),
            _buildField(
              label: "Výchozí stanice",
              initial: _edited.departureStation,
              onChanged: (v) =>
              _edited = _edited.copyWith(departureStation: v),
            ),
            _buildField(
              label: "Aktuální stanice",
              initial: _edited.currentStation,
              onChanged: (v) =>
              _edited = _edited.copyWith(currentStation: v),
            ),
            _buildField(
              label: "Cílová stanice",
              initial: _edited.destinationStation,
              onChanged: (v) =>
              _edited = _edited.copyWith(destinationStation: v),
            ),

            const SizedBox(height: 12),
            const Text("UZB / JZB", style: TextStyle(color: Colors.white, fontSize: 18)),
            _buildField(
              label: "Místo UZB",
              initial: _edited.uzbLocation,
              onChanged: (v) =>
              _edited = _edited.copyWith(uzbLocation: v),
            ),
            _buildField(
              label: "Provedl UZB",
              initial: _edited.uzbPerformedBy,
              onChanged: (v) =>
              _edited = _edited.copyWith(uzbPerformedBy: v),
            ),
            _buildField(
              label: "Místo JZB",
              initial: _edited.jzbLocation,
              onChanged: (v) =>
              _edited = _edited.copyWith(jzbLocation: v),
            ),
            _buildField(
              label: "Provedl JZB",
              initial: _edited.jzbPerformedBy,
              onChanged: (v) =>
              _edited = _edited.copyWith(jzbPerformedBy: v),
            ),

            const SizedBox(height: 12),
            const Text("Systémy", style: TextStyle(color: Colors.white, fontSize: 18)),
            _buildField(
              label: "NBÜ stav",
              initial: _edited.nbuStatus,
              onChanged: (v) =>
              _edited = _edited.copyWith(nbuStatus: v),
            ),
            _buildField(
              label: "Max. povolená rychlost",
              initial: _edited.topSpeedAllowed,
              isNumber: true,
              onChanged: (v) =>
              _edited = _edited.copyWith(topSpeedAllowed: v),
            ),
            _buildField(
              label: "Ovládání dveří",
              initial: _edited.doorControlStatus,
              onChanged: (v) =>
              _edited = _edited.copyWith(doorControlStatus: v),
            ),
            _buildField(
              label: "Napájení",
              initial: _edited.powerSupplyStatus,
              onChanged: (v) =>
              _edited = _edited.copyWith(powerSupplyStatus: v),
            ),
            _buildField(
              label: "Vozy pro vyšší rychlost",
              initial: _edited.highSpeedCarsStatus,
              onChanged: (v) =>
              _edited = _edited.copyWith(highSpeedCarsStatus: v),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
