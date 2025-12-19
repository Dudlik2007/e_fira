// lib/report_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'report_data.dart';
import 'train_selection_page.dart';

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

  // Header (název, číslo vlaku, datum)
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
            child: Text(data.trainNumber, style: _headerTextStyle),
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

  // Barevný indikátor (NBÜ, dveře, atd.)
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
          child: Text(value, textAlign: TextAlign.center, style: _indicatorValueStyle),
        ),
      ],
    );
  }

  // Malý box (stanice)
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
          Text(value, style: _valueTextStyle, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // Buňka s daty (zobrazí '–––' červeně, pokud je hodnota prázdná)
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

  // Ikona (D/K)
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
            child: Text(value, style: _valueTextStyle, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ÚZB / JZB buňka
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

  // Řádek s detailem (pro ÚZB/JZB)
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
      Expanded(flex: 5, child: _dataCell('Nejvyšší rychlost vlaku:', data.maxSpeed, bg: darkCell)),
      const SizedBox(width: 6),
      Expanded(flex: 5, child: _dataCell('Brzdící procento:', brakePercentDisplay, bg: lightCell)),
    ]);
  }

  Widget _buildTrainLengthAndBrakeTypesRow() {
    return Row(children: [
      Expanded(flex: 3, child: _dataCell('Délka vlaku:', data.trainLength, bg: darkCell)),
      const SizedBox(width: 6),
      Expanded(flex: 2, child: _dataCell('Počet náprav:', data.trainWheels.toString(), bg: darkCell, align: TextAlign.center)),
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
              'činná: ${data.activeVehiclesWeight}  dopr.: ${data.transportVehiclesWeight}  vlak: ${data.totalVehiclesWeight}',
              bg: lightCell)),
    ]);
  }

  Widget _buildBrakeChecksRow() {
    final now = DateTime.now();
    // Scenarios simulation: 50% chance UZB is older than 4 hours.
    final bool simulateOldUzb = Random().nextBool();

    DateTime uzbTime;
    String jzbKdy = "";
    String jzbKde = data.jzbLocation; // Original value
    String jzbKym = data.jzbPerformedBy; // Original value

    if (simulateOldUzb) {
      // --- Case 1: UZB is "old" (4-24h ago), so JZB is performed now. ---
      final jzbTime = now;
      jzbKdy = DateFormat('HH:mm').format(jzbTime);
      jzbKde = data.currentStation;
      jzbKym = 'vlakvedoucí';

      // UZB must be between 4 and 24 hours older than JZB.
      final randomHours = Random().nextInt(20); // 0-19
      final randomMinutes = Random().nextInt(60); // 0-59
      uzbTime = jzbTime.subtract(Duration(hours: 4 + randomHours, minutes: randomMinutes));

    } else {
      // --- Case 2: UZB is "fresh" (<4h ago), so no new JZB is needed. ---
      final randomMinutes = Random().nextInt(4 * 60); // 0-239 minutes
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

  Widget _buildParkingForceRow() {
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
            onPressed: () {
              // TODO: doplnit výpočet síly
            },
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


  // Velká tabulka (Sestavená z menších částí)
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
          _buildParkingForceRow(),
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
                    Expanded(child: _coloredIndicatorSplit('Horní rychl. - vozy', data.highSpeedCarsStatus, Colors.brown)),
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
                  //  otevřít VV
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
