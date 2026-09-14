import 'package:charset/charset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_fira/report_data.dart';
import 'package:e_fira/storage_service.dart';
import 'package:e_fira/train_editor_page.dart';

void main() {
  test('CP1250 round-trip preserves Czech characters in TJŘ files', () {
    const text = 'Jízdní řád pro Bržděnku 10542 – Praha, Ostrava';

    final bytes = StorageService.encodeWindows1250(text);
    final decoded = StorageService.decodeText(bytes);

    expect(decoded, text);
  });

  testWidgets('Train number accepts alphanumeric values like Os10542', (tester) async {
    final train = ReportData(
      trainName: 'Test',
      trainNumber: 'Os10542',
      maxSpeed: '120',
      trainLength: '200',
      trainCars: 2,
      trainWheels: '4',
      brakeTypeD: '0',
      brakeTypeK: '0',
      brakeMode: '',
      brakingModeP: '0',
      brakingModeR: '0',
      brakingModeRMg: '0',
      brakePercent: '0',
      brakingPercentageActual: '0',
      brakingPercentageRequired: '0',
      brakingPercentageMissing: '0',
      activeVehiclesCount: 0,
      transportVehiclesCount: 0,
      totalVehiclesCount: 0,
      activeVehiclesWeight: 0,
      transportVehiclesWeight: 0,
      totalVehiclesWeight: 0,
      departureStation: '',
      currentStation: '',
      destinationStation: '',
      uzbLocation: '',
      uzbPerformedBy: '',
      jzbLocation: '',
      jzbPerformedBy: '',
      nbuStatus: '',
      topSpeedAllowed: '',
      doorControlStatus: '',
      powerSupplyStatus: '',
      highSpeedCarsStatus: '',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TrainEditorPage(
          train: train,
          onSave: (_) {},
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) => widget is TextFormField && widget.initialValue == 'Os10542',
      ),
      findsOneWidget,
    );
  });
}
