import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:e_fira/report_data.dart'; // Nezapomeň na správnou cestu k tvému ReportData

// Sem Drift vygeneruje zbytek kódu (bude to chvíli svítit červeně, to je normální)
part 'app_database.g.dart';

// 1. Definice tabulky (Třída musí dědit z Table)
class Trains extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Přidáno .named('...'), aby Drift nehledal 'train_name' ale 'trainName'
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

@DriftDatabase(tables: [Trains])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ==========================================
  // NOVÉ FUNKCE PRO ZÍSKÁVÁNÍ DAT
  // ==========================================
// Změněno z Train na TrainsCompanion pro insert a update
  Future<int> insertTrain(TrainsCompanion train) {
    return into(trains).insert(train);
  }

  Future<bool> updateTrain(TrainsCompanion train) {
    return update(trains).replace(train);
  }

  Future<int> deleteTrain(Train train) {
    return delete(trains).delete(train);
  }
  // 1. Získá seznam úplně všech vlaků
  Future<List<Train>> getAllTrains() {
    return select(trains).get();
  }

  // 2. Získá jen unikátní názvy cílových stanic (pro nějaký dropdown/filtr)
  Future<List<String>> getUniqueDestinations() async {
    // Vytvoříme vlastní dotaz, abychom vybrali jen unikátní hodnoty
    final query = selectOnly(trains, distinct: true)
      ..addColumns([trains.destinationStation]);
      
    final results = await query.map((row) => row.read(trains.destinationStation)).get();
    
    // Vyfiltrujeme případné null hodnoty
    return results.where((s) => s != null).cast<String>().toList();
  }

  // 3. Vyhledá konkrétní vlak podle jeho čísla (např. 10542)
  Future<Train?> getTrainByNumber(int number) {
    return (select(trains)..where((t) => t.trainNumber.equals(number))).getSingleOrNull();
  }
}

// 3. Funkce pro připojení k SQLite souboru
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Najde bezpečnou složku pro aplikaci (na Windows to bude v AppData, na Androidu v interním úložišti)
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'databaze.sqlite'));
    
    return NativeDatabase.createInBackground(file);
  });
}



// Převodník z nové SQLite databáze do starého formátu aplikace
extension TrainToReportData on Train {
  ReportData toReportData() {
    // Nasimulujeme řádek z CSV, aby si to tvoje existující třída ReportData uměla sama přebrat
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

