class ReportData {
  // Základní informace o vlaku
  final String trainName;
  final String trainNumber;
  final String maxSpeed;
  final String trainLength;
  final int trainCars;
  final String trainWheels;
  final String brakeTypeD;
  final String brakeTypeK;
  final String brakeMode;
  final String brakingModeP;
  final String brakingModeR;
  final String brakingModeRMg;
  final String brakePercent;
  final String brakingPercentageActual;
  final String brakingPercentageRequired;
  final String brakingPercentageMissing;

  // Váhy a počty vozů
  final int activeVehiclesCount;
  final int transportVehiclesCount;
  final int totalVehiclesCount;
  final double activeVehiclesWeight;
  final double transportVehiclesWeight;
  final double totalVehiclesWeight;

  // Stanice a průjezdy
  final String departureStation;
  final String currentStation;
  final String destinationStation;

  // UZB / JZB
  final String uzbLocation;
  final String uzbPerformedBy;

  final String jzbLocation;
  final String jzbPerformedBy;

  // Systémy a stav
  final String nbuStatus;
  final String topSpeedAllowed;
  final String doorControlStatus;
  final String powerSupplyStatus;
  final String highSpeedCarsStatus;

  ReportData({
    required this.trainName,
    required this.trainNumber,
    required this.maxSpeed,
    required this.trainLength,
    required this.trainCars,
    required this.trainWheels,
    required this.brakeTypeD,
    required this.brakeTypeK,
    required this.brakeMode,
    required this.brakingModeP,
    required this.brakingModeR,
    required this.brakingModeRMg,
    required this.brakePercent,
    required this.brakingPercentageActual,
    required this.brakingPercentageRequired,
    required this.brakingPercentageMissing,
    required this.activeVehiclesCount,
    required this.transportVehiclesCount,
    required this.totalVehiclesCount,
    required this.activeVehiclesWeight,
    required this.transportVehiclesWeight,
    required this.totalVehiclesWeight,
    required this.departureStation,
    required this.currentStation,
    required this.destinationStation,
    required this.uzbLocation,
    required this.uzbPerformedBy,
    required this.jzbLocation,
    required this.jzbPerformedBy,
    required this.nbuStatus,
    required this.topSpeedAllowed,
    required this.doorControlStatus,
    required this.powerSupplyStatus,
    required this.highSpeedCarsStatus,
  });

  // export do řádku CSV
  List<String> toCsvRow() {
    return [
      trainName,
      trainNumber,
      maxSpeed,
      trainLength,
      trainCars.toString(),
      trainWheels,
      brakeTypeD,
      brakeTypeK,
      brakeMode,
      brakingModeP,
      brakingModeR,
      brakingModeRMg,
      brakePercent,
      brakingPercentageActual,
      brakingPercentageRequired,
      brakingPercentageMissing,
      activeVehiclesCount.toString(),
      transportVehiclesCount.toString(),
      totalVehiclesCount.toString(),
      activeVehiclesWeight.toString(),
      transportVehiclesWeight.toString(),
      totalVehiclesWeight.toString(),
      departureStation,
      currentStation,
      destinationStation,
      uzbLocation,
      uzbPerformedBy,
      jzbLocation,
      jzbPerformedBy,
      nbuStatus,
      doorControlStatus,
      powerSupplyStatus,
      highSpeedCarsStatus,
      topSpeedAllowed,
    ];
  }

// import z řádku CSV
  factory ReportData.fromCsvRow(List<String> row) {
    String safe(int i) => (i < row.length) ? row[i] : '';
    int safeInt(int i) => int.tryParse(safe(i)) ?? 0;
    double safeDouble(int i) => double.tryParse(safe(i)) ?? 0.0;

    return ReportData(
      trainName: safe(0),
      trainNumber: safe(1),
      maxSpeed: safe(2),
      trainLength: safe(3),
      trainCars: safeInt(4),
      trainWheels: safe(5),
      brakeTypeD: safe(6),
      brakeTypeK: safe(7),
      brakeMode: safe(8),
      brakingModeP: safe(9),
      brakingModeR: safe(10),
      brakingModeRMg: safe(11),
      brakePercent: safe(12),
      brakingPercentageActual: safe(13),
      brakingPercentageRequired: safe(14),
      brakingPercentageMissing: safe(15),
      activeVehiclesCount: safeInt(16),
      transportVehiclesCount: safeInt(17),
      totalVehiclesCount: safeInt(18),
      activeVehiclesWeight: safeDouble(19),
      transportVehiclesWeight: safeDouble(20),
      totalVehiclesWeight: safeDouble(21),
      departureStation: safe(22),
      currentStation: safe(23),
      destinationStation: safe(24),
      uzbLocation: safe(25),
      uzbPerformedBy: safe(26),
      jzbLocation: safe(27),
      jzbPerformedBy: safe(28),
      nbuStatus: safe(29),
      doorControlStatus: safe(30),
      powerSupplyStatus: safe(31),
      highSpeedCarsStatus: safe(32),
      topSpeedAllowed: safe(33),
    );
  }

  static List<String> csvHeader() {
    return [
      'trainName','trainNumber','maxSpeed','trainLength','trainCars','trainWheels',
      'brakeTypeD','brakeTypeK','brakeMode','brakingModeP','brakingModeR','brakingModeRMg',
      'brakePercent','brakingPercentageActual','brakingPercentageRequired','brakingPercentageMissing',
      'activeVehiclesCount','transportVehiclesCount','totalVehiclesCount',
      'activeVehiclesWeight','transportVehiclesWeight','totalVehiclesWeight',
      'departureStation','currentStation','destinationStation',
      'uzbLocation','uzbPerformedBy','jzbLocation','jzbPerformedBy',
      'nbuStatus','doorControlStatus','powerSupplyStatus','highSpeedCarsStatus','topSpeedAllowed'
    ];
  }
}
