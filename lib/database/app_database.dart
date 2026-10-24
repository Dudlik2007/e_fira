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
  
  // ---> NOVÝ PŘÍZNAK PRO FORK (RUČNĚ vs. VÝKAZ VOZIDEL) <---
  BoolColumn get useVehicleRoster => boolean().named('useVehicleRoster').withDefault(const Constant(false))();

  TextColumn get trainName => text().named('trainName').nullable()();
  IntColumn get trainNumber => integer().named('trainNumber').nullable()();
  IntColumn get maxSpeed => integer().named('maxSpeed').nullable()();
  IntColumn get trainLength => integer().named('trainLength').nullable()();
  IntColumn get trainCars => integer().named('trainCars').nullable()();
  TextColumn get trainWheels => text().named('trainWheels').nullable()();
  IntColumn get brakeTypeD => integer().named('brakeTypeD').nullable()();
  IntColumn get brakeTypeK => integer().named('brakeTypeK').nullable()();
  TextColumn get brakeMode => text().named('brakeMode').nullable()();
  IntColumn get brakingModeP => integer().named('brakingModeP').nullable()();
  IntColumn get brakingModeR => integer().named('brakingModeR').nullable()();
  IntColumn get brakingModeRMg => integer().named('brakingModeRMg').nullable()();
  IntColumn get brakePercent => integer().named('brakePercent').nullable()();
  IntColumn get brakingPercentageActual => integer().named('brakingPercentageActual').nullable()();
  IntColumn get brakingPercentageRequired => integer().named('brakingPercentageRequired').nullable()();
  IntColumn get brakingPercentageMissing => integer().named('brakingPercentageMissing').nullable()();
  IntColumn get activeVehiclesCount => integer().named('activeVehiclesCount').nullable()();
  IntColumn get transportVehiclesCount => integer().named('transportVehiclesCount').nullable()();
  IntColumn get totalVehiclesCount => integer().named('totalVehiclesCount').nullable()();
  RealColumn get activeVehiclesWeight => real().named('activeVehiclesWeight').nullable()();
  RealColumn get transportVehiclesWeight => real().named('transportVehiclesWeight').nullable()();
  RealColumn get totalVehiclesWeight => real().named('totalVehiclesWeight').nullable()();
  TextColumn get departureStation => text().named('departureStation').nullable()();
  TextColumn get currentStation => text().named('currentStation').nullable()();
  TextColumn get destinationStation => text().named('destinationStation').nullable()();
  TextColumn get uzbLocation => text().named('uzbLocation').nullable()();
  TextColumn get uzbPerformedBy => text().named('uzbPerformedBy').nullable()();
  TextColumn get jzbLocation => text().named('jzbLocation').nullable()();
  TextColumn get jzbPerformedBy => text().named('jzbPerformedBy').nullable()();
  TextColumn get nbuStatus => text().named('nbuStatus').nullable()();
  TextColumn get doorControlStatus => text().named('doorControlStatus').nullable()();
  TextColumn get powerSupplyStatus => text().named('powerSupplyStatus').nullable()();
  TextColumn get highSpeedCarsStatus => text().named('highSpeedCarsStatus').nullable()();
  RealColumn get topSpeedAllowed => real().named('topSpeedAllowed').nullable()();
  TextColumn get tjrFileName => text().named('tjrFileName').nullable()();

  @override
  String get tableName => 'trains';
}

// ==========================================
// 2. NOVÁ TABULKA: KATALOG VOZIDEL (Na výběr)
// ==========================================
class VehicleCatalog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get seriesName => text()(); // Např. "Vectron 193", "Bmz"
  BoolColumn get isLocomotive => boolean().withDefault(const Constant(false))();
  
  RealColumn get length => real()(); // Délka v metrech
  RealColumn get emptyWeight => real()(); // Vlastní hmotnost
  IntColumn get axles => integer()(); // Počet náprav
  
  TextColumn get defaultBrakeType => text()(); // "K", "D", "Šp"
  RealColumn get defaultBrakeWeight => real()(); // Brzdicí váha
}

// ==========================================
// 3. NOVÁ TABULKA: VÝKAZ VOZIDEL (Zařazené vozy)
// ==========================================
class TrainVehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Propojení na tabulku Trains (Když se smaže vlak, smažou se i jeho vozy)
  IntColumn get trainId => integer().customConstraint('REFERENCES trains(id) ON DELETE CASCADE')();
  
  IntColumn get position => integer()(); // Pořadí vlaku (1 = první)
  TextColumn get uicNumber => text().nullable()(); // 12místné UIC
  
  // Technické údaje (zkopírované z katalogu při přidání, aby šly upravit pro konkrétní jízdu)
  TextColumn get vehicleName => text()(); 
  RealColumn get length => real()();
  RealColumn get emptyWeight => real()();
  RealColumn get loadWeight => real().withDefault(const Constant(0.0))(); // Hmotnost nákladu/cestujících
  IntColumn get axles => integer()();
  TextColumn get brakeType => text()(); 
  RealColumn get brakeWeight => real()();
}

// === Registrace všech 3 tabulek do databáze ===
@DriftDatabase(tables: [Trains, VehicleCatalog, TrainVehicles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
      
    final results = await query.map((row) => row.read(trains.destinationStation)).get();
    return results.where((s) => s != null).cast<String>().toList();
  }

  Future<Train?> getTrainByNumber(int number) {
    return (select(trains)..where((t) => t.trainNumber.equals(number))).getSingleOrNull();
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