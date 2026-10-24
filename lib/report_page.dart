// lib/report_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'report_data.dart';
import 'train_selection_page.dart';
// TODO: Zde později odkomentuješ import pro Výkaz vozidel
// import 'vehicle_roster_page.dart'; 

class ReportPage extends StatelessWidget {
  final ReportData data;
  const ReportPage({super.key, required this.data});

  // --- Constants for styling ---
  static const double _pad = 0.0;
  static const Color panelBg = Color(0xFF000000);
  static const Color cellBg = Color(0xFF59697A);
  static const Color darkCell = Color(0xFF263238);
  static const Color lightCell = Color(0xFF37474F);

  static const TextStyle _headerTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle _labelTextStyle = TextStyle(fontSize: 11, color: Colors.white70);
  static const TextStyle _valueTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle _smallValueTextStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle _indicatorLabelStyle = TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold);
  static const TextStyle _indicatorValueStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white);

  // --- Widget Parts ---

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _pad, vertical: 10),
      color: panelBg,
      child: Row(
        children: [
          const Text('ZPRÁVA O BRZDĚNÍ', style: _headerTextStyle),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Colors.white, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(data.trainNumber.isNotEmpty ? data.trainNumber : '???', style: _headerTextStyle),
          ),
          const Expanded(child: Divider(color: Colors.white, thickness: 1)),
          const SizedBox(width: 8),
          Text(
            DateFormat('dd.MM.yyyy').format(now),
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _coloredIndicatorSplit(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          color: Colors.black87,
          child: Text(label, textAlign: TextAlign.center, style: _indicatorLabelStyle, softWrap: true),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          color: color,
          child: Text(value.isNotEmpty ? value : '–––', textAlign: TextAlign.center, style: _indicatorValueStyle),
        ),
      ],
    );
  }

  Widget _smallInfoBox({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1720),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelTextStyle),
          const SizedBox(height: 4),
          Text(value.isNotEmpty ? value : '–––', style: _valueTextStyle, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _dataCell(String title, String value, {Color bg = cellBg, TextAlign align = TextAlign.left}) {
    final bool isEmpty = value.trim().isEmpty || value == '---' || value == '–––';
    final displayValue = isEmpty ? '–––' : value;
    final valueStyle = isEmpty ? _valueTextStyle.copyWith(color: Colors.redAccent) : _valueTextStyle;

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Column(
        crossAxisAlignment: align == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          if (title.isNotEmpty) Text(title, style: _labelTextStyle, overflow: TextOverflow.ellipsis),
          if (title.isNotEmpty) const SizedBox(height: 4),
          Text(displayValue, textAlign: align, style: valueStyle, softWrap: true),
        ],
      ),
    );
  }

  Widget _iconCell(String iconChar, String value, {Color bg = cellBg}) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 1.2),
            ),
            child: Text(iconChar, style: _smallValueTextStyle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(value.isNotEmpty ? value : '0', style: _valueTextStyle, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _brakeCheckCell({required String title, required String kdy, required String where, required String by, Color bg = cellBg}) {
    return Container(
      color: bg,
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: _labelTextStyle),
        const SizedBox(height: 4),
        _detailRow('kdy:', kdy),
        _detailRow('kde:', where),
        _detailRow('kým:', by),
      ]),
    );
  }

  Widget _detailRow(String label, String value) {
    final bool isEmpty = value.trim().isEmpty;
    final valueStyle = isEmpty ? _smallValueTextStyle.copyWith(color: Colors.redAccent) : _smallValueTextStyle;
    final displayValue = isEmpty ? '–––' : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(children: [
        SizedBox(width: 32, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70))),
        Expanded(child: Text(displayValue, style: valueStyle, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  // --- Big Table Rows ---

  Widget _buildSpeedAndBrakingPercentageRow() {
    String brakePercentDisplay =
        'skut.: ${data.brakingPercentageActual}  potř.: ${data.brakingPercentageRequired}  chyb.: ${data.brakingPercentageMissing}';
    return Row(children: [
      Expanded(flex: 5, child: _dataCell('Nejvyšší rychlost vlaku:', '${data.maxSpeed} km/h', bg: darkCell)),
      const SizedBox(width: 6),
      Expanded(flex: 5, child: _dataCell('Brzdící procento:', brakePercentDisplay, bg: lightCell)),
    ]);
  }

  Widget _buildTrainLengthAndBrakeTypesRow() {
    return Row(children: [
      Expanded(flex: 3, child: _dataCell('Délka vlaku:', '${data.trainLength} m', bg: darkCell)),
      const SizedBox(width: 6),
      Expanded(flex: 2, child: _dataCell('Počet náprav:', data.trainWheels, bg: darkCell, align: TextAlign.center)),
      const SizedBox(width: 6),
      Expanded(
        flex: 5,
        child: Container(
          color: lightCell,
          padding: const EdgeInsets.all(6),
          child: Column(children: [
            const Text('Počet zap. brzd (druh brzdy):', style: _labelTextStyle),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(child: _iconCell('D', data.brakeTypeD)),
              const SizedBox(width: 6),
              Expanded(child: _iconCell('K', data.brakeTypeK)),
            ]),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildVehicleCountsAndWeightsRow() {
    return Row(children: [
      Expanded(
          flex: 5,
          child: _dataCell(
              'Počet ŽKV:',
              'činná: ${data.activeVehiclesCount}  dopr.: ${data.transportVehiclesCount}  vlak: ${data.totalVehiclesCount}',
              bg: darkCell)),
      const SizedBox(width: 6),
      Expanded(
          flex: 5,
          child: _dataCell(
              'Hmotnost ŽKV:',
              'činná: ${data.activeVehiclesWeight}  dopr.: ${data.transportVehiclesWeight}  vlak: ${data.totalVehiclesWeight} t',
              bg: lightCell)),
    ]);
  }

  Widget _buildBrakeChecksRow() {
    final now = DateTime.now();
    // TODO: Zde by se v budoucnu měl načítat reálný čas z databáze místo random simulace
    final bool simulateOldUzb = Random().nextBool();

    DateTime uzbTime;
    String jzbKdy = "";
    String jzbKde = data.jzbLocation; 
    String jzbKym = data.jzbPerformedBy; 

    if (simulateOldUzb) {
      final jzbTime = now;
      jzbKdy = DateFormat('HH:mm').format(jzbTime);
      jzbKde = data.currentStation.isNotEmpty ? data.currentStation : '–––';
      jzbKym = 'vlakvedoucí';

      final randomHours = Random().nextInt(20);
      final randomMinutes = Random().nextInt(60);
      uzbTime = jzbTime.subtract(Duration(hours: 4 + randomHours, minutes: randomMinutes));
    } else {
      final randomMinutes = Random().nextInt(4 * 60);
      uzbTime = now.subtract(Duration(minutes: randomMinutes));
    }

    return Row(children: [
      Expanded(
          child: _brakeCheckCell(
              title: 'ÚZB vykonána:',
              kdy: DateFormat('HH:mm').format(uzbTime),
              where: data.uzbLocation,
              by: data.uzbPerformedBy,
              bg: darkCell)),
      const SizedBox(width: 6),
      Expanded(
          child: _brakeCheckCell(
              title: 'JZB vykonána:',
              kdy: jzbKdy,
              where: jzbKde,
              by: jzbKym,
              bg: lightCell)),
    ]);
  }
  
  Widget _buildBrakingModeRow() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 4, child: _dataCell('Stanovený režim brzdění', data.brakeMode, bg: darkCell)),
      const SizedBox(width: 6),
      Expanded(
        flex: 6,
        child: Container(
          color: lightCell,
          padding: const EdgeInsets.all(6),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Počet zap. brzd (režim brzdění)', style: _labelTextStyle),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Text('P: ${data.brakingModeP}', style: _smallValueTextStyle),
                  Text('R: ${data.brakingModeR}', style: _smallValueTextStyle),
                  Text('R+Mg: ${data.brakingModeRMg}', style: _smallValueTextStyle),
                ]),
              ]),
        ),
      ),
    ]);
  }

  Widget _buildParkingForceRow(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightCell,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Potřebná zajišťovací síla [Fpark] [kN]', style: _labelTextStyle),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: () => _showParkingForceDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('VYPOČÍTAT ZAJIŠŤOVACÍ SÍLU', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- DIALOG PRO VÝPOČET ZAJIŠŤOVACÍ SÍLY ---
  void _showParkingForceDialog(BuildContext context) {
    // Zde můžeš implementovat přesný vzorec pro Fpark.
    // Příklad hrubého odhadu: Hmotnost vlaku * sklon (promile) * konstanta.
    final double weight = data.totalVehiclesWeight;
    final double force = weight > 0 ? (weight * 0.05) : 0.0; 

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkCell,
          title: const Text('Zajišťovací síla', style: TextStyle(color: Colors.white)),
          content: Text(
            weight > 0 
              ? 'Při celkové hmotnosti $weight t je orientační potřebná zajišťovací síla:\n\n${force.toStringAsFixed(1)} kN\n\n(Zde doplň přesný výpočet ze spádu)' 
              : 'Pro výpočet musíte nejprve zadat celkovou hmotnost vlaku.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ZAVŘÍT', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSecurableVehiclesRow(){
      return Row(children: [
        Expanded(
          flex: 6,
          child: _dataCell('ŽKV s upotřebitelnou zajišťovací brzdou', '–––', bg: darkCell),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 4,
          child: _dataCell('Brzdící váha', '–––', bg: lightCell),
        ),
      ]);
  }

  Widget _buildLastVehicleRow(){
      return Row(children: [
        Expanded(flex: 5, child: _dataCell('Poslední vozidlo vlaku', '–––', bg: darkCell)),
        const SizedBox(width: 6),
        Expanded(flex: 5, child: _dataCell('Brzdicí váha (celkem)', '–––', bg: lightCell)),
      ]);
  }

  Widget _buildSignedByRow(){
      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 220,
          child: _dataCell('Sepsal', data.uzbPerformedBy, bg: darkCell, align: TextAlign.right),
        ),
      );
  }

  Widget _buildBigTable(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(_pad),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          _buildSpeedAndBrakingPercentageRow(),
          const SizedBox(height: 6),
          _buildTrainLengthAndBrakeTypesRow(),
          const SizedBox(height: 6),
          _buildVehicleCountsAndWeightsRow(),
          const SizedBox(height: 6),
          _buildBrakeChecksRow(),
          const SizedBox(height: 6),
           Container(
            width: double.infinity,
            color: darkCell,
            padding: const EdgeInsets.all(6),
            child: const Text('Další informace o vlaku:', style: _labelTextStyle),
          ),
          const SizedBox(height: 6),
          _buildBrakingModeRow(),
          const SizedBox(height: 6),
          _buildParkingForceRow(context),
          const SizedBox(height: 6),
          _buildSecurableVehiclesRow(),
          const SizedBox(height: 6),
          _buildLastVehicleRow(),
          const SizedBox(height: 6),
          _buildSignedByRow(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _pad),
                child: Row(
                  children: [
                    Expanded(child: _smallInfoBox(title: 'Výchozí ŽST:', value: data.departureStation)),
                    Expanded(child: _smallInfoBox(title: 'Sepsáno v:', value: data.currentStation)),
                    Expanded(child: _smallInfoBox(title: 'Konečná ŽST:', value: data.destinationStation)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _pad),
                child: Row(
                  children: [
                    Expanded(child: _coloredIndicatorSplit('Překl. záchran. brzdy', data.nbuStatus, Colors.green)),
                    const SizedBox(width: 4),
                    Expanded(child: _coloredIndicatorSplit('Systém ovládání dveří', data.doorControlStatus, Colors.amber)),
                    const SizedBox(width: 4),
                    Expanded(child: _coloredIndicatorSplit('Napájení na 25 kV AC', data.powerSupplyStatus, Colors.lightBlue)),
                    const SizedBox(width: 4),
                    Expanded(child: _coloredIndicatorSplit('Rychlostní profil', data.highSpeedCarsStatus, Colors.brown)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              _buildBigTable(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey[900],
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white12,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('ZAVŘÍT BEZ POTVRZENÍ'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.pushAndRemoveUntil(
                       context,
                       MaterialPageRoute(builder: (context) => const TrainSelectionPage()),
                       (Route<dynamic> route) => false,
                     );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('POTVRDIT A ZAVŘÍT'),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // --- PROPOJENÍ NA VÝKAZ VOZIDEL ---
                  /* 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Předáme vlaku ID nebo jeho instanci
                      builder: (context) => VehicleRosterPage(trainNumber: data.trainNumber), 
                    ),
                  );
                  */
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Výkaz vozidel se připravuje...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('OTEVŘÍT VV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}