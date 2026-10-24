import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'database/app_database.dart';
import 'stations_database.dart';

class TrainEditorPage extends StatefulWidget {
  final Train? train;
  final Future<void> Function(TrainsCompanion) onSave;

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
  
  // NOVÁ STAVOVÁ PROMĚNNÁ PRO PŘEPÍNAČ
  bool useVehicleRoster = false;

  String? trainName;
  int? trainNumber;
  int? maxSpeed;
  int? trainLength;
  String? trainWheels;
  String? tjrFileName;

  int? brakeTypeD;
  int? brakeTypeK;
  String? brakeMode;
  int? brakingModeP;
  int? brakingModeR;
  int? brakingModeRMg;

  String? departureStation;
  String? currentStation;
  String? destinationStation;
  String? uzbLocation;
  String? uzbPerformedBy;
  String? jzbLocation;
  String? jzbPerformedBy;

  String? nbuStatus;
  String? doorControlStatus;
  String? powerSupplyStatus;
  String? highSpeedCarsStatus;

  late TextEditingController _actualCtrl;
  late TextEditingController _requiredCtrl;
  late TextEditingController _missingCtrl;

  late TextEditingController _activeVehiclesCountCtrl;
  late TextEditingController _transportVehiclesCountCtrl;
  late TextEditingController _totalVehiclesCountCtrl;

  late TextEditingController _activeVehiclesWeightCtrl;
  late TextEditingController _transportVehiclesWeightCtrl;
  late TextEditingController _totalVehiclesWeightCtrl;

  @override
  void initState() {
    super.initState();
    final t = widget.train;

    // Načteme stav přepínače z databáze
    useVehicleRoster = t?.useVehicleRoster ?? false;

    trainName = t?.trainName ?? "Nový vlak";
    trainNumber = t?.trainNumber;
    maxSpeed = t?.maxSpeed;
    trainLength = t?.trainLength;
    trainWheels = t?.trainWheels;
    tjrFileName = t?.tjrFileName;

    brakeTypeD = t?.brakeTypeD;
    brakeTypeK = t?.brakeTypeK;
    brakeMode = t?.brakeMode;
    brakingModeP = t?.brakingModeP;
    brakingModeR = t?.brakingModeR;
    brakingModeRMg = t?.brakingModeRMg;

    departureStation = t?.departureStation;
    currentStation = t?.currentStation;
    destinationStation = t?.destinationStation;

    uzbLocation = t?.uzbLocation;
    uzbPerformedBy = t?.uzbPerformedBy;
    jzbLocation = t?.jzbLocation;
    jzbPerformedBy = t?.jzbPerformedBy;

    nbuStatus = t?.nbuStatus;
    doorControlStatus = t?.doorControlStatus;
    powerSupplyStatus = t?.powerSupplyStatus;
    highSpeedCarsStatus = t?.highSpeedCarsStatus;

    _actualCtrl = TextEditingController(text: t?.brakingPercentageActual?.toString() ?? '');
    _requiredCtrl = TextEditingController(text: t?.brakingPercentageRequired?.toString() ?? '');
    _missingCtrl = TextEditingController(text: t?.brakingPercentageMissing?.toString() ?? '');

    _activeVehiclesCountCtrl = TextEditingController(text: t?.activeVehiclesCount?.toString() ?? '');
    _transportVehiclesCountCtrl = TextEditingController(text: t?.transportVehiclesCount?.toString() ?? '');
    _totalVehiclesCountCtrl = TextEditingController(text: t?.totalVehiclesCount?.toString() ?? '');

    _activeVehiclesWeightCtrl = TextEditingController(text: t?.activeVehiclesWeight?.toString() ?? '');
    _transportVehiclesWeightCtrl = TextEditingController(text: t?.transportVehiclesWeight?.toString() ?? '');
    _totalVehiclesWeightCtrl = TextEditingController(text: t?.totalVehiclesWeight?.toString() ?? '');
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
    }
  }

  void _recalcTotalVehiclesCount() {
    final active = int.tryParse(_activeVehiclesCountCtrl.text) ?? 0;
    final transport = int.tryParse(_transportVehiclesCountCtrl.text) ?? 0;
    final total = active + transport;
    _totalVehiclesCountCtrl.text = total.toString();
  }

  void _recalcTotalVehiclesWeight() {
    final active = double.tryParse(_activeVehiclesWeightCtrl.text) ?? 0.0;
    final transport = double.tryParse(_transportVehiclesWeightCtrl.text) ?? 0.0;
    final total = active + transport;

    final totalStr = total.toStringAsFixed(total.truncateToDouble() == total ? 0 : 1);
    _totalVehiclesWeightCtrl.text = totalStr;
  }

  Future<void> _save() async {
    final companion = TrainsCompanion(
      id: widget.train == null ? const drift.Value.absent() : drift.Value(widget.train!.id),
      
      // Ukládáme novou proměnnou!
      useVehicleRoster: drift.Value(useVehicleRoster),

      trainName: drift.Value(trainName),
      trainNumber: drift.Value(trainNumber),
      maxSpeed: drift.Value(maxSpeed),
      trainLength: drift.Value(trainLength),
      trainWheels: drift.Value(trainWheels),
      tjrFileName: drift.Value(tjrFileName),

      brakeTypeD: drift.Value(brakeTypeD),
      brakeTypeK: drift.Value(brakeTypeK),
      brakeMode: drift.Value(brakeMode),
      brakingModeP: drift.Value(brakingModeP),
      brakingModeR: drift.Value(brakingModeR),
      brakingModeRMg: drift.Value(brakingModeRMg),
      
      brakingPercentageActual: drift.Value(int.tryParse(_actualCtrl.text)),
      brakingPercentageRequired: drift.Value(int.tryParse(_requiredCtrl.text)),
      brakingPercentageMissing: drift.Value(int.tryParse(_missingCtrl.text)),

      activeVehiclesCount: drift.Value(int.tryParse(_activeVehiclesCountCtrl.text)),
      transportVehiclesCount: drift.Value(int.tryParse(_transportVehiclesCountCtrl.text)),
      totalVehiclesCount: drift.Value(int.tryParse(_totalVehiclesCountCtrl.text)),

      activeVehiclesWeight: drift.Value(double.tryParse(_activeVehiclesWeightCtrl.text)),
      transportVehiclesWeight: drift.Value(double.tryParse(_transportVehiclesWeightCtrl.text)),
      totalVehiclesWeight: drift.Value(double.tryParse(_totalVehiclesWeightCtrl.text)),

      departureStation: drift.Value(departureStation),
      currentStation: drift.Value(currentStation),
      destinationStation: drift.Value(destinationStation),

      uzbLocation: drift.Value(uzbLocation),
      uzbPerformedBy: drift.Value(uzbPerformedBy),
      jzbLocation: drift.Value(jzbLocation),
      jzbPerformedBy: drift.Value(jzbPerformedBy),

      nbuStatus: drift.Value(nbuStatus),
      doorControlStatus: drift.Value(doorControlStatus),
      powerSupplyStatus: drift.Value(powerSupplyStatus),
      highSpeedCarsStatus: drift.Value(highSpeedCarsStatus),
      
      brakePercent: drift.Value(widget.train?.brakePercent),
      topSpeedAllowed: drift.Value(widget.train?.topSpeedAllowed),
      trainCars: drift.Value(widget.train?.trainCars),
    );

    await widget.onSave(companion);
    if (!mounted) return;
    Navigator.pop(context);
  }

  // ============== HELPER METODY PRO KRESLENÍ UI ==============
  
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
        initialValue: currentValue,
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
        title: const Text("Editor vlaku"),
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
                      initial: trainName,
                      onChanged: (v) => trainName = v,
                    ),
                    _buildField(
                      label: "Číslo vlaku",
                      initial: trainNumber?.toString(),
                      isNumber: true,
                      onChanged: (v) {
                        setState(() {
                          trainNumber = int.tryParse(v);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildRow2(
                    _buildField(
                      label: "Nejvyšší rychlost vlaku",
                      initial: maxSpeed?.toString(),
                      isNumber: true,
                      onChanged: (v) => maxSpeed = int.tryParse(v),
                    ),
                    _buildAutocompleteField(
                      label: "Název souboru TJŘ",
                      initialValue: tjrFileName ?? '',
                      suggestions: trainNumber != null ? [trainNumber.toString()] : [],
                      onChanged: (v) => tjrFileName = v,
                    ),
                  ),
                ]),

                // --- NOVÝ PŘEPÍNAČ: RUČNĚ vs. VÝKAZ ---
                _buildSectionCard("Režim zadávání parametrů vlaku", [
                  SwitchListTile(
                    title: const Text(
                      "Počítat automaticky z Výkazu vozidel",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      "Délka, hmotnosti a brzdící procenta se vypočítají ze složení soupravy.",
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    activeColor: Colors.blueAccent,
                    contentPadding: EdgeInsets.zero,
                    value: useVehicleRoster,
                    onChanged: (bool value) {
                      setState(() {
                        useVehicleRoster = value;
                      });
                    },
                  ),
                ]),

                if (useVehicleRoster) ...[
                  // --- ZOBRAZENO POUZE KDYŽ JE ZAPNUTÝ VÝKAZ VOZIDEL ---
                  _buildSectionCard("Složení soupravy", [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.train_outlined, color: Colors.blueAccent, size: 40),
                          const SizedBox(height: 8),
                          const Text(
                            "Údaje o vlaku budou automaticky vypočítány z výkazu vozidel.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (widget.train == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Nejprve vlak uložte, až poté můžete přidávat vozy.')),
                                );
                              } else {
                                // TODO: Navigace do nového Editoru Výkazu vozidel (Katalogu)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Editor soupravy se připravuje...')),
                                );
                              }
                            },
                            icon: const Icon(Icons.edit_document),
                            label: const Text("SESTAVIT VÝKAZ VOZIDEL"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ] else ...[
                  // --- ZOBRAZENO POUZE KDYŽ SE VŠE PÍŠE RUČNĚ (JAKO DOSUD) ---
                  _buildSectionCard("Ruční parametry (Hmotnost a Délka)", [
                    _buildRow2(
                      _buildField(
                        label: "Délka vlaku (m)",
                        initial: trainLength?.toString(),
                        isNumber: true,
                        onChanged: (v) => trainLength = int.tryParse(v),
                      ),
                      _buildField(
                        label: "Počet náprav",
                        initial: trainWheels,
                        onChanged: (v) => trainWheels = v,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildRow2(
                      _buildField(
                        label: "Činná vozidla (počet)",
                        controller: _activeVehiclesCountCtrl,
                        isNumber: true,
                        onChanged: (v) => _recalcTotalVehiclesCount(),
                      ),
                      _buildField(
                        label: "Hmotnost činných (t)",
                        controller: _activeVehiclesWeightCtrl,
                        isNumber: true,
                        onChanged: (v) => _recalcTotalVehiclesWeight(),
                      ),
                    ),
                    _buildRow2(
                      _buildField(
                        label: "Doprovodná vozidla (počet)",
                        controller: _transportVehiclesCountCtrl,
                        isNumber: true,
                        onChanged: (v) => _recalcTotalVehiclesCount(),
                      ),
                      _buildField(
                        label: "Hmotnost doprovodných (t)",
                        controller: _transportVehiclesWeightCtrl,
                        isNumber: true,
                        onChanged: (v) => _recalcTotalVehiclesWeight(),
                      ),
                    ),
                    _buildRow2(
                      _buildField(
                        label: "Vozidla celkem (automaticky)",
                        controller: _totalVehiclesCountCtrl,
                        isNumber: true,
                        readOnly: true,
                        onChanged: (v) {},
                      ),
                      _buildField(
                        label: "Hmotnost celkem (t) (automaticky)",
                        controller: _totalVehiclesWeightCtrl,
                        isNumber: true,
                        readOnly: true,
                        onChanged: (v) {},
                      ),
                    ),
                  ]),

                  _buildSectionCard("Brzdy", [
                    _buildRow3(
                      _buildField(
                        label: "Typ brzdy D (počet)",
                        initial: brakeTypeD?.toString(),
                        isNumber: true,
                        onChanged: (v) => brakeTypeD = int.tryParse(v),
                      ),
                      _buildField(
                        label: "Typ brzdy K (počet)",
                        initial: brakeTypeK?.toString(),
                        isNumber: true,
                        onChanged: (v) => brakeTypeK = int.tryParse(v),
                      ),
                      _buildDropdownField(
                        label: "Stanovený režim brzdění",
                        value: brakeMode,
                        items: const ['P', 'R', 'R+Mg'],
                        onChanged: (v) => brakeMode = v,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildRow3(
                      _buildField(
                        label: "Režim P (počet)",
                        initial: brakingModeP?.toString(),
                        isNumber: true,
                        onChanged: (v) => brakingModeP = int.tryParse(v),
                      ),
                      _buildField(
                        label: "Režim R (počet)",
                        initial: brakingModeR?.toString(),
                        isNumber: true,
                        onChanged: (v) => brakingModeR = int.tryParse(v),
                      ),
                      _buildField(
                        label: "Režim R+Mg (počet)",
                        initial: brakingModeRMg?.toString(),
                        isNumber: true,
                        onChanged: (v) => brakingModeRMg = int.tryParse(v),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildRow3(
                      _buildField(
                        label: "Skutečné brzd. %",
                        controller: _actualCtrl,
                        isNumber: true,
                        onChanged: (v) => _recalcMissingBrakes(),
                      ),
                      _buildField(
                        label: "Potřebné brzd. %",
                        controller: _requiredCtrl,
                        isNumber: true,
                        onChanged: (v) => _recalcMissingBrakes(),
                      ),
                      _buildField(
                        label: "Chybějící brzd. %",
                        controller: _missingCtrl,
                        isNumber: true,
                        onChanged: (v) {},
                      ),
                    ),
                  ]),
                ], // KONEC PODMÍNKY if (useVehicleRoster)

                _buildSectionCard("Stanice", [
                  _buildRow3(
                    _buildAutocompleteField(
                      label: "Výchozí ŽST",
                      initialValue: departureStation ?? '',
                      suggestions: czStationsList,
                      onChanged: (v) => departureStation = v,
                    ),
                    _buildAutocompleteField(
                      label: "Sepsáno v ŽST",
                      initialValue: currentStation ?? '',
                      suggestions: czStationsList,
                      onChanged: (v) => currentStation = v,
                    ),
                    _buildAutocompleteField(
                      label: "Konečná ŽST",
                      initialValue: destinationStation ?? '',
                      suggestions: czStationsList,
                      onChanged: (v) => destinationStation = v,
                    ),
                  ),
                ]),

                _buildSectionCard("ÚZB / JZB", [
                  _buildRow2(
                    _buildAutocompleteField(
                      label: "Kde provedena ÚZB",
                      initialValue: uzbLocation ?? '',
                      suggestions: czStationsList,
                      onChanged: (v) => uzbLocation = v,
                    ),
                    _buildField(
                      label: "Kým provedena ÚZB (Sepsal)",
                      initial: uzbPerformedBy,
                      onChanged: (v) => uzbPerformedBy = v,
                    ),
                  ),
                  _buildRow2(
                    _buildAutocompleteField(
                      label: "Kde provedena JZB",
                      initialValue: jzbLocation ?? '',
                      suggestions: czStationsList,
                      onChanged: (v) => jzbLocation = v,
                    ),
                    _buildField(
                      label: "Kým provedena JZB",
                      initial: jzbPerformedBy,
                      onChanged: (v) => jzbPerformedBy = v,
                    ),
                  ),
                ]),

                _buildSectionCard("Indikátory a Systémy", [
                  _buildRow2(
                    _buildField(
                      label: "NBÜ (Přemostění záchran. brzdy)",
                      initial: nbuStatus,
                      onChanged: (v) => nbuStatus = v,
                    ),
                    _buildDropdownField(
                      label: "Systémy otvírání dveří",
                      value: doorControlStatus,
                      items: const ['TB 5', 'TB 0', 'TB-S', 'SSOD', 'CODS', 'LAT'],
                      onChanged: (v) => doorControlStatus = v,
                    ),
                  ),
                  _buildRow2(
                    _buildField(
                      label: "Napájení na 25 kV AC",
                      initial: powerSupplyStatus,
                      onChanged: (v) => powerSupplyStatus = v,
                    ),
                    _buildAutocompleteField(
                      label: "Rychlostní profil (Horní rychlostníky)",
                      initialValue: highSpeedCarsStatus ?? '',
                      suggestions: const ['PASS 1', 'PASS 2'],
                      onChanged: (v) => highSpeedCarsStatus = v,
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