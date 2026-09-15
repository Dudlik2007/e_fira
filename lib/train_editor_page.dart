import 'package:flutter/material.dart';
import 'report_data.dart';
import 'stations_database.dart'; // Databáze stanic

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

  // Controllery pro Brzdy
  late TextEditingController _actualCtrl;
  late TextEditingController _requiredCtrl;
  late TextEditingController _missingCtrl;

  // Controllery pro Počty vozidel
  late TextEditingController _activeVehiclesCountCtrl;
  late TextEditingController _transportVehiclesCountCtrl;
  late TextEditingController _totalVehiclesCountCtrl;

  // Controllery pro Hmotnosti vozidel
  late TextEditingController _activeVehiclesWeightCtrl;
  late TextEditingController _transportVehiclesWeightCtrl;
  late TextEditingController _totalVehiclesWeightCtrl;

  @override
  void initState() {
    super.initState();
    _edited = widget.train;

    _actualCtrl = TextEditingController(text: _edited.brakingPercentageActual);
    _requiredCtrl = TextEditingController(text: _edited.brakingPercentageRequired);
    _missingCtrl = TextEditingController(text: _edited.brakingPercentageMissing);

    _activeVehiclesCountCtrl = TextEditingController(text: _edited.activeVehiclesCount.toString());
    _transportVehiclesCountCtrl = TextEditingController(text: _edited.transportVehiclesCount.toString());
    _totalVehiclesCountCtrl = TextEditingController(text: _edited.totalVehiclesCount.toString());

    _activeVehiclesWeightCtrl = TextEditingController(text: _edited.activeVehiclesWeight.toString());
    _transportVehiclesWeightCtrl = TextEditingController(text: _edited.transportVehiclesWeight.toString());
    _totalVehiclesWeightCtrl = TextEditingController(text: _edited.totalVehiclesWeight.toString());
  }

  @override
  void dispose() {
    _actualCtrl.dispose();
    _requiredCtrl.dispose();
    _missingCtrl.dispose();

    _activeVehiclesCountCtrl.dispose();
    _transportVehiclesCountCtrl.dispose();
    _totalVehiclesCountCtrl.dispose();

    _activeVehiclesWeightCtrl.dispose();
    _transportVehiclesWeightCtrl.dispose();
    _totalVehiclesWeightCtrl.dispose();

    super.dispose();
  }

  void _recalcMissingBrakes() {
    final actual = int.tryParse(_actualCtrl.text) ?? 0;
    final required = int.tryParse(_requiredCtrl.text) ?? 0;

    final diff = actual - required;
    final missingStr = diff < 0 ? diff.toString() : '0';

    if (_missingCtrl.text != missingStr) {
      _missingCtrl.text = missingStr;
      _edited = _edited.copyWith(brakingPercentageMissing: missingStr);
    }
  }

  void _recalcTotalVehiclesCount() {
    final active = int.tryParse(_activeVehiclesCountCtrl.text) ?? 0;
    final transport = int.tryParse(_transportVehiclesCountCtrl.text) ?? 0;
    final total = active + transport;

    _totalVehiclesCountCtrl.text = total.toString();
    _edited = _edited.copyWith(totalVehiclesCount: total);
  }

  void _recalcTotalVehiclesWeight() {
    final active = double.tryParse(_activeVehiclesWeightCtrl.text) ?? 0.0;
    final transport = double.tryParse(_transportVehiclesWeightCtrl.text) ?? 0.0;
    final total = active + transport;

    final totalStr = total.toStringAsFixed(total.truncateToDouble() == total ? 0 : 1);

    _totalVehiclesWeightCtrl.text = totalStr;
    _edited = _edited.copyWith(totalVehiclesWeight: total);
  }

  Future<void> _save() async {
    await widget.onSave(_edited);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget _buildField({
    required String label,
    String? initial,
    TextEditingController? controller,
    bool isNumber = false,
    bool readOnly = false,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        initialValue: controller == null ? initial : null,
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(color: readOnly ? Colors.white60 : Colors.white, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
          filled: true,
          fillColor: readOnly ? const Color(0xFF141414) : const Color(0xFF1E1E1E),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildAutocompleteField({
    required String label,
    required String initialValue,
    required List<String> suggestions,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: initialValue),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return suggestions.where((String option) {
            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          onChanged(selection);
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onChanged,
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: const Color(0xFF2C2C2C),
              elevation: 4,
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 280,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return ListTile(
                      dense: true,
                      title: Text(option, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final currentValue = (value != null && items.contains(value)) ? value : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
        dropdownColor: const Color(0xFF2C2C2C),
        style: const TextStyle(color: Colors.white, fontSize: 13),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRow2(Widget f1, Widget f2) {
    return Row(
      children: [
        Expanded(child: f1),
        const SizedBox(width: 8),
        Expanded(child: f2),
      ],
    );
  }

  Widget _buildRow3(Widget f1, Widget f2, Widget f3) {
    return Row(
      children: [
        Expanded(child: f1),
        const SizedBox(width: 8),
        Expanded(child: f2),
        const SizedBox(width: 8),
        Expanded(child: f3),
      ],
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
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
        title: const Text("Editor vlaku (Windows)"),
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.save, size: 18),
              label: const Text("Uložit"),
              onPressed: _save,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                
                _buildSectionCard("Základní informace", [
                  _buildRow2(
                    _buildField(
                      label: "Název vlaku",
                      initial: _edited.trainName,
                      onChanged: (v) => _edited = _edited.copyWith(trainName: v),
                    ),
                    _buildField(
                      label: "Číslo vlaku",
                      initial: _edited.trainNumber,
                      onChanged: (v) {
                        // Přidán setState, aby se po napsání čísla vlaku hned zaktualizoval našeptávač u TJŘ
                        setState(() {
                          _edited = _edited.copyWith(trainNumber: v);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildRow2(
                    _buildField(
                      label: "Nejvyšší rychlost vlaku",
                      initial: _edited.maxSpeed,
                      isNumber: true,
                      onChanged: (v) => _edited = _edited.copyWith(maxSpeed: v),
                    ),
                    _buildField(
                      label: "Délka vlaku (m)",
                      initial: _edited.trainLength,
                      isNumber: true,
                      onChanged: (v) => _edited = _edited.copyWith(trainLength: v),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildRow2(
                    _buildField(
                      label: "Počet náprav",
                      initial: _edited.trainWheels,
                      isNumber: true,
                      onChanged: (v) => _edited = _edited.copyWith(trainWheels: v),
                    ),
                    // VRÁCENO: Soubor TJŘ s našeptávačem provázaným na Číslo vlaku
                    _buildAutocompleteField(
                      label: "Název souboru TJŘ",
                      initialValue: _edited.tjrFileName ?? '',
                      // Zde je to kouzlo: Pokud je zadané číslo vlaku, nabízíme ho jako možnost pro TJŘ
                      suggestions: _edited.trainNumber.isNotEmpty ? [_edited.trainNumber] : [],
                      onChanged: (v) => _edited = _edited.copyWith(tjrFileName: v),
                    ),
                  ),
                ]),

                _buildSectionCard("Brzdy", [
                  _buildRow3(
                    _buildField(
                      label: "Typ brzdy D (počet)",
                      initial: _edited.brakeTypeD,
                      onChanged: (v) => _edited = _edited.copyWith(brakeTypeD: v),
                    ),
                    _buildField(
                      label: "Typ brzdy K (počet)",
                      initial: _edited.brakeTypeK,
                      onChanged: (v) => _edited = _edited.copyWith(brakeTypeK: v),
                    ),
                    _buildDropdownField(
                      label: "Stanovený režim brzdění",
                      value: _edited.brakeMode,
                      items: const ['P', 'R', 'R+Mg'],
                      onChanged: (v) => _edited = _edited.copyWith(brakeMode: v ?? ''),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildRow3(
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
                    _buildField(
                      label: "Režim R+Mg (počet)",
                      initial: _edited.brakingModeRMg,
                      onChanged: (v) => _edited = _edited.copyWith(brakingModeRMg: v),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildRow3(
                    _buildField(
                      label: "Skutečné brzd. %",
                      controller: _actualCtrl,
                      isNumber: true,
                      onChanged: (v) {
                        _edited = _edited.copyWith(brakingPercentageActual: v);
                        _recalcMissingBrakes();
                      },
                    ),
                    _buildField(
                      label: "Potřebné brzd. %",
                      controller: _requiredCtrl,
                      isNumber: true,
                      onChanged: (v) {
                        _edited = _edited.copyWith(brakingPercentageRequired: v);
                        _recalcMissingBrakes();
                      },
                    ),
                    _buildField(
                      label: "Chybějící brzd. %",
                      controller: _missingCtrl,
                      isNumber: true,
                      onChanged: (v) => _edited = _edited.copyWith(brakingPercentageMissing: v),
                    ),
                  ),
                ]),

                _buildSectionCard("Vozidla a Hmotnosti", [
                  _buildRow2(
                    _buildField(
                      label: "Činná vozidla (počet)",
                      controller: _activeVehiclesCountCtrl,
                      isNumber: true,
                      onChanged: (v) {
                        _edited = _edited.copyWith(activeVehiclesCount: int.tryParse(v) ?? 0);
                        _recalcTotalVehiclesCount();
                      },
                    ),
                    _buildField(
                      label: "Hmotnost činných (t)",
                      controller: _activeVehiclesWeightCtrl,
                      isNumber: true,
                      onChanged: (v) {
                        _edited = _edited.copyWith(activeVehiclesWeight: double.tryParse(v) ?? 0.0);
                        _recalcTotalVehiclesWeight();
                      },
                    ),
                  ),
                  _buildRow2(
                    _buildField(
                      label: "Doprovodná vozidla (počet)",
                      controller: _transportVehiclesCountCtrl,
                      isNumber: true,
                      onChanged: (v) {
                        _edited = _edited.copyWith(transportVehiclesCount: int.tryParse(v) ?? 0);
                        _recalcTotalVehiclesCount();
                      },
                    ),
                    _buildField(
                      label: "Hmotnost doprovodných (t)",
                      controller: _transportVehiclesWeightCtrl,
                      isNumber: true,
                      onChanged: (v) {
                        _edited = _edited.copyWith(transportVehiclesWeight: double.tryParse(v) ?? 0.0);
                        _recalcTotalVehiclesWeight();
                      },
                    ),
                  ),
                  _buildRow2(
                    _buildField(
                      label: "Vozidla celkem (automaticky)",
                      controller: _totalVehiclesCountCtrl,
                      isNumber: true,
                      readOnly: true,
                      onChanged: (v) => _edited = _edited.copyWith(totalVehiclesCount: int.tryParse(v) ?? 0),
                    ),
                    _buildField(
                      label: "Hmotnost celkem (t) (automaticky)",
                      controller: _totalVehiclesWeightCtrl,
                      isNumber: true,
                      readOnly: true,
                      onChanged: (v) => _edited = _edited.copyWith(totalVehiclesWeight: double.tryParse(v) ?? 0.0),
                    ),
                  ),
                ]),

                _buildSectionCard("Stanice", [
                  _buildRow3(
                    _buildAutocompleteField(
                      label: "Výchozí ŽST",
                      initialValue: _edited.departureStation,
                      suggestions: czStationsList,
                      onChanged: (v) => _edited = _edited.copyWith(departureStation: v),
                    ),
                    _buildAutocompleteField(
                      label: "Sepsáno v ŽST",
                      initialValue: _edited.currentStation,
                      suggestions: czStationsList,
                      onChanged: (v) => _edited = _edited.copyWith(currentStation: v),
                    ),
                    _buildAutocompleteField(
                      label: "Konečná ŽST",
                      initialValue: _edited.destinationStation,
                      suggestions: czStationsList,
                      onChanged: (v) => _edited = _edited.copyWith(destinationStation: v),
                    ),
                  ),
                ]),

                _buildSectionCard("ÚZB / JZB", [
                  _buildRow2(
                    _buildAutocompleteField(
                      label: "Kde provedena ÚZB",
                      initialValue: _edited.uzbLocation,
                      suggestions: czStationsList,
                      onChanged: (v) => _edited = _edited.copyWith(uzbLocation: v),
                    ),
                    _buildField(
                      label: "Kým provedena ÚZB (Sepsal)",
                      initial: _edited.uzbPerformedBy,
                      onChanged: (v) => _edited = _edited.copyWith(uzbPerformedBy: v),
                    ),
                  ),
                  _buildRow2(
                    _buildAutocompleteField(
                      label: "Kde provedena JZB",
                      initialValue: _edited.jzbLocation,
                      suggestions: czStationsList,
                      onChanged: (v) => _edited = _edited.copyWith(jzbLocation: v),
                    ),
                    _buildField(
                      label: "Kým provedena JZB",
                      initial: _edited.jzbPerformedBy,
                      onChanged: (v) => _edited = _edited.copyWith(jzbPerformedBy: v),
                    ),
                  ),
                ]),

                _buildSectionCard("Indikátory a Systémy", [
                  _buildRow2(
                    _buildField(
                      label: "NBÜ (Přemostění záchran. brzdy)",
                      initial: _edited.nbuStatus,
                      onChanged: (v) => _edited = _edited.copyWith(nbuStatus: v),
                    ),
                    _buildDropdownField(
                      label: "Systémy otvírání dveří",
                      value: _edited.doorControlStatus,
                      items: const ['TB 5', 'TB 0', 'TB-S', 'SSOD', 'CODS', 'LAT'],
                      onChanged: (v) => _edited = _edited.copyWith(doorControlStatus: v ?? ''),
                    ),
                  ),
                  _buildRow2(
                    _buildField(
                      label: "Napájení na 25 kV AC",
                      initial: _edited.powerSupplyStatus,
                      onChanged: (v) => _edited = _edited.copyWith(powerSupplyStatus: v),
                    ),
                    _buildAutocompleteField(
                      label: "Rychlostní profil (Horní rychlostníky)",
                      initialValue: _edited.highSpeedCarsStatus,
                      suggestions: const ['PASS 1', 'PASS 2'],
                      onChanged: (v) => _edited = _edited.copyWith(highSpeedCarsStatus: v),
                    ),
                  ),
                ]),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}