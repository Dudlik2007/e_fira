// lib/report_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'report_data.dart';
import 'train_selection_page.dart';

class ReportPage extends StatelessWidget {
  final ReportData data;
  const ReportPage({super.key, required this.data});

  static const double _pad = 0.0;
  static const Color panelBg = Color(0xFF000000);
  static const Color cellBg = Color(0xFF59697A);

  // Header (název, číslo vlaku, datum)
  Widget header(BuildContext context) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _pad, vertical: 10),
      color: panelBg,
      child: Row(
        children: [
          const Text(
            'ZPRÁVA O BRZDĚNÍ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Colors.white, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              data.trainNumber,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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

  // Barevný indikátor (NBÜ, dveře, 25kV, horní rychl.)
  Widget coloredIndicatorSplit(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          color: Colors.black87,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
            softWrap: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          color: color,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Malý box (stanice)
  Widget _SmallInfoBox({required String title, required String value}) {
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
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Buňka s daty
  Widget dataCell(String title, String value, {Color bg = cellBg, TextAlign align = TextAlign.left}) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Column(
        crossAxisAlignment: align == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          if (title.isNotEmpty)
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70), overflow: TextOverflow.ellipsis),
          if (title.isNotEmpty) const SizedBox(height: 4),
          Text(value,
              textAlign: align,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              softWrap: true),
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
            child: Text(iconChar, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold , color: Colors.white), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ÚZB / JZB
  Widget _brakeCheckCell({required String title, required String where, required String by, Color bg = cellBg}) {
    final now = DateTime.now();
    final uzbTime = now.subtract(const Duration(hours: 4));
    return Container(
      color: bg,
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        const SizedBox(height: 4),
        _detailRow('kdy:', where),
        _detailRow('kde:', where),
        _detailRow('kým:', by),
      ]),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(children: [
        SizedBox(width: 32, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  // Velká tabulka
  Widget bigTable(BuildContext context) {
    const Color darkCell = Color(0xFF263238);
    const Color lightCell = Color(0xFF37474F);
    final now = DateTime.now();
    final uzbTime = now.subtract(const Duration(hours: 4));

    String brakePercentDisplay =
        'skut.: ${data.brakingPercentageActual}  potf.: ${data.brakingPercentageRequired}  chyb.: ${data.brakingPercentageMissing}';

    return Container(
      margin: const EdgeInsets.all(_pad),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: panelBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)),
      child: Column(children: [
        Row(children: [
          Expanded(flex: 5, child: dataCell('Nejvyšší rychlost vlaku:', data.maxSpeed, bg: darkCell)),
          const SizedBox(width: 6),
          Expanded(flex: 5, child: dataCell('Brzdící procento:', brakePercentDisplay, bg: lightCell)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(flex: 3, child: dataCell('Délka vlaku:', data.trainLength, bg: darkCell)),
          const SizedBox(width: 6),
          Expanded(flex: 2, child: dataCell('', data.trainWheels.toString(), bg: darkCell, align: TextAlign.center)),
          const SizedBox(width: 6),
          Expanded(
            flex: 5,
            child: Container(
              color: lightCell,
              padding: const EdgeInsets.all(6),
              child: Column(children: [
                const Text('Počet zap. brzd (druh brzdy):', style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 4),
                Row(children: [
                  Expanded(child: _iconCell('D', data.brakeTypeD)),
                  const SizedBox(width: 6),
                  Expanded(child: _iconCell('K', data.brakeTypeK)),
                ]),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(flex: 5, child: dataCell('Počet ŽKV:', 'činná: ${data.activeVehiclesCount}  dopr.: ${data.transportVehiclesCount}  vlak: ${data.totalVehiclesCount}', bg: darkCell)),
          const SizedBox(width: 6),
          Expanded(flex: 5, child: dataCell('Hmotnost ŽKV:', 'činná: ${data.activeVehiclesWeight}  dopr.: ${data.transportVehiclesWeight}  vlak: ${data.totalVehiclesWeight}', bg: lightCell)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _brakeCheckCell(title: 'ÚZB vykonána:',  where: data.uzbLocation, by: data.uzbPerformedBy, bg: darkCell)),
          const SizedBox(width: 6),
          Expanded(child: _brakeCheckCell(title: 'JZB vykonána:',  where: data.jzbLocation, by: data.jzbPerformedBy, bg: lightCell)),
        ]),
        const SizedBox(height: 6),
        Container(width: double.infinity, color: darkCell, padding: const EdgeInsets.all(6), child: Text('Další informace o vlaku:', style: const TextStyle(fontSize: 11, color: Colors.white70))),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 4, child: dataCell('Stanovený režim brzdění', data.brakeMode, bg: darkCell)),
          const SizedBox(width: 6),
          Expanded(
            flex: 6,
            child: Container(
              color: lightCell,
              padding: const EdgeInsets.all(6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Počet zap. brzd (režim brzdění)', style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Text('P: ${data.brakingModeP}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Color(0xffffffff),)),
                  Text('R: ${data.brakingModeR}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Color(0xffffffff),)),
                  Text('R+Mg: ${data.brakingModeRMg}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Color(0xffffffff),)),
                ]),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea( // 🔹 Přidá ochranu proti hornímu a dolnímu překrytí
        child: SingleChildScrollView(
          child: Column(
            children: [
              header(context),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _pad),
                child: Row(
                  children: [
                    Expanded(child: _SmallInfoBox(title: 'Výchozí ŽST:', value: data.departureStation)),
                    Expanded(child: _SmallInfoBox(title: 'Sepsáno v:', value: data.currentStation)),
                    Expanded(child: _SmallInfoBox(title: 'Konečná ŽST:', value: data.destinationStation)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _pad),
                child: Row(
                  children: [
                    Expanded(child: coloredIndicatorSplit('Překl. záchran. brzdy', data.nbuStatus, Colors.green)),
                    const SizedBox(width: 4),
                    Expanded(child: coloredIndicatorSplit('Systém ovládání dveří', data.doorControlStatus, Colors.amber)),
                    const SizedBox(width: 4),
                    Expanded(child: coloredIndicatorSplit('Napájení na 25 kV AC', data.powerSupplyStatus, Colors.lightBlue)),
                    const SizedBox(width: 4),
                    Expanded(child: coloredIndicatorSplit('Horní rychl. - vozy', data.highSpeedCarsStatus, Colors.brown)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              bigTable(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea( // 🔹 ochrana i pro spodní část
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const TrainSelectionPage()),
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
                  // TODO: otevřít VV
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

  Widget bottomBar(BuildContext context) {
  const double _pad = 12;

  return Container(
    padding: const EdgeInsets.all(_pad),
    color: Colors.grey[900],
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // zavře aktuální bez potvrzení
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('ZAVŘÍT BEZ POTVRZENÍ'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Otevře TrainSelectionPage a nahradí tuto stránku
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const TrainSelectionPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('POTVRDIT A ZAVŘÍT'),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // otevře VV
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white12,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('OTEVŘÍT VV'),
        ),
      ],
    ),
  );
}
}