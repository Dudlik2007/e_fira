import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:e_fira/report_data.dart'; // Nezapomeň na správnou cestu k tvému ReportData

part 'app_database.g.dart';

// ==========================================
// 1. EXISTUJÍCÍ TABULKA VLAKŮ
// ==========================================
class Trains extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get trainName => text().named('trainName').nullable()();
  TextColumn get trainNumber => text().named('trainNumber').nullable()();
  IntColumn get maxSpeed => integer().named('maxSpeed').nullable()();
  IntColumn get trainLength => integer().named('trainLength').nullable()();
  IntColumn get trainCars => integer().named('trainCars').nullable()();
  TextColumn get trainWheels => text().named('trainWheels').nullable()();
  IntColumn get brakeTypeD => integer().named('brakeTypeD').nullable()();
  IntColumn get brakeTypeK => integer().named('brakeTypeK').nullable()();
  TextColumn get brakeMode => text().named('brakeMode').nullable()();
  IntColumn get brakingModeP => integer().named('brakingModeP').nullable()();
  IntColumn get brakingModeR => integer().named('brakingModeR').nullable()();
  IntColumn get brakingModeRMg =>
      integer().named('brakingModeRMg').nullable()();
  IntColumn get brakePercent => integer().named('brakePercent').nullable()();
  IntColumn get brakingPercentageActual =>
      integer().named('brakingPercentageActual').nullable()();
  IntColumn get brakingPercentageRequired =>
      integer().named('brakingPercentageRequired').nullable()();
  IntColumn get brakingPercentageMissing =>
      integer().named('brakingPercentageMissing').nullable()();
  IntColumn get activeVehiclesCount =>
      integer().named('activeVehiclesCount').nullable()();
  IntColumn get transportVehiclesCount =>
      integer().named('transportVehiclesCount').nullable()();
  IntColumn get totalVehiclesCount =>
      integer().named('totalVehiclesCount').nullable()();
  RealColumn get activeVehiclesWeight =>
      real().named('activeVehiclesWeight').nullable()();
  RealColumn get transportVehiclesWeight =>
      real().named('transportVehiclesWeight').nullable()();
  RealColumn get totalVehiclesWeight =>
      real().named('totalVehiclesWeight').nullable()();
  TextColumn get departureStation =>
      text().named('departureStation').nullable()();
  TextColumn get currentStation => text().named('currentStation').nullable()();
  TextColumn get destinationStation =>
      text().named('destinationStation').nullable()();
  TextColumn get uzbLocation => text().named('uzbLocation').nullable()();
  TextColumn get uzbPerformedBy => text().named('uzbPerformedBy').nullable()();
  TextColumn get jzbLocation => text().named('jzbLocation').nullable()();
  TextColumn get jzbPerformedBy => text().named('jzbPerformedBy').nullable()();
  TextColumn get nbuStatus => text().named('nbuStatus').nullable()();
  TextColumn get doorControlStatus =>
      text().named('doorControlStatus').nullable()();
  TextColumn get powerSupplyStatus =>
      text().named('powerSupplyStatus').nullable()();
  TextColumn get highSpeedCarsStatus =>
      text().named('highSpeedCarsStatus').nullable()();
  RealColumn get topSpeedAllowed =>
      real().named('topSpeedAllowed').nullable()();
  TextColumn get tjrFileName => text().named('tjrFileName').nullable()();

  @override
  String get tableName => 'trains';
}

@DriftDatabase(tables: [Trains])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 3) {
        final existingTables = await customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name IN ('vehicle_catalog', 'train_vehicles')",
        ).map((row) => row.read<String>('name')).get();

        if (existingTables.contains('train_vehicles')) {
          await migrator.deleteTable('train_vehicles');
        }
        if (existingTables.contains('vehicle_catalog')) {
          await migrator.deleteTable('vehicle_catalog');
        }

        final trainColumns = await customSelect(
          'PRAGMA table_info(trains)',
        ).get();
        final hasUseVehicleRoster = trainColumns.any(
          (row) => row.data['name'] == 'useVehicleRoster',
        );
        if (hasUseVehicleRoster) {
          await customStatement(
            'ALTER TABLE trains DROP COLUMN "useVehicleRoster"',
          );
        }
      }
    },
  );

  // ==========================================
  // FUNKCE PRO ZÍSKÁVÁNÍ DAT
  // ==========================================
  Future<int> insertTrain(TrainsCompanion train) {
    return into(trains).insert(train);
  }

  Future<bool> updateTrain(TrainsCompanion train) {
    return update(trains).replace(train);
  }

  Future<int> deleteTrain(Train train) {
    return delete(trains).delete(train);
  }

  Future<List<Train>> getAllTrains() {
    return select(trains).get();
  }

  Future<List<String>> getUniqueDestinations() async {
    final query = selectOnly(trains, distinct: true)
      ..addColumns([trains.destinationStation]);

    final results = await query
        .map((row) => row.read(trains.destinationStation))
        .get();
    return results.where((s) => s != null).cast<String>().toList();
  }

  Future<Train?> getTrainByNumber(String number) {
    return (select(
      trains,
    )..where((t) => t.trainNumber.equals(number))).getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'databaze.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// Převodník z nové SQLite databáze do starého formátu aplikace
extension TrainToReportData on Train {
  ReportData toReportData() {
    return ReportData.fromCsvRow([
      trainName ?? '',
      trainNumber?.toString() ?? '',
      maxSpeed?.toString() ?? '',
      trainLength?.toString() ?? '',
      trainCars?.toString() ?? '',
      trainWheels ?? '',
      brakeTypeD?.toString() ?? '',
      brakeTypeK?.toString() ?? '',
      brakeMode ?? '',
      brakingModeP?.toString() ?? '',
      brakingModeR?.toString() ?? '',
      brakingModeRMg?.toString() ?? '',
      brakePercent?.toString() ?? '',
      brakingPercentageActual?.toString() ?? '',
      brakingPercentageRequired?.toString() ?? '',
      brakingPercentageMissing?.toString() ?? '',
      activeVehiclesCount?.toString() ?? '',
      transportVehiclesCount?.toString() ?? '',
      totalVehiclesCount?.toString() ?? '',
      activeVehiclesWeight?.toString() ?? '',
      transportVehiclesWeight?.toString() ?? '',
      totalVehiclesWeight?.toString() ?? '',
      departureStation ?? '',
      currentStation ?? '',
      destinationStation ?? '',
      uzbLocation ?? '',
      uzbPerformedBy ?? '',
      jzbLocation ?? '',
      jzbPerformedBy ?? '',
      nbuStatus ?? '',
      doorControlStatus ?? '',
      powerSupplyStatus ?? '',
      highSpeedCarsStatus ?? '',
      topSpeedAllowed?.toString() ?? '',
      tjrFileName ?? '',
    ]);
  }
}
