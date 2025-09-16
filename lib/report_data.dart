class ReportData {
  // Základní informace o vlaku
  final String trainName;
  final String trainNumber;
  final String maxSpeed;
  final String trainLength;
  final int trainCars;
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
 /* final String doorSystem;
  final String power25kV;
 */ final String topSpeedAllowed;
  final String doorControlStatus;
  final String powerSupplyStatus;
  final String highSpeedCarsStatus;

  ReportData({
    required this.trainName,
    required this.trainNumber,
    required this.maxSpeed,
    required this.trainLength,
    required this.trainCars,
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
  /*  required this.doorSystem,
    required this.power25kV,
  */  required this.topSpeedAllowed,
    required this.doorControlStatus,
    required this.powerSupplyStatus,
    required this.highSpeedCarsStatus,
  });

  // Export do CSV
  List<String> toCsvRow() {
    return [
      trainName,
      trainNumber,
      maxSpeed,
      trainLength,
      trainCars.toString(),
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
     /// doorSystem,
     /// power25kV,
      topSpeedAllowed,
      doorControlStatus,
      powerSupplyStatus,
      highSpeedCarsStatus,
    ];
  }

  // Import z CSV
  factory ReportData.fromCsvRow(List<String> row) {
    return ReportData(
      trainName: row[0],
      trainNumber: row[1],
      maxSpeed: row[2],
      trainLength: row[3],
      trainCars: int.parse(row[4]),
      brakeTypeD: row[5],
      brakeTypeK: row[6],
      brakeMode: row[7],
      brakingModeP: row[8],
      brakingModeR: row[9],
      brakingModeRMg: row[10],
      brakePercent: row[11],
      brakingPercentageActual: row[12],
      brakingPercentageRequired: row[13],
      brakingPercentageMissing: row[14],
      activeVehiclesCount: int.parse(row[15]),
      transportVehiclesCount: int.parse(row[16]),
      totalVehiclesCount: int.parse(row[17]),
      activeVehiclesWeight: double.parse(row[18]),
      transportVehiclesWeight: double.parse(row[19]),
      totalVehiclesWeight: double.parse(row[20]),
      departureStation: row[21],
      currentStation: row[22],
      destinationStation: row[23],

      uzbLocation: row[25],
      uzbPerformedBy: row[26],

      jzbLocation: row[28],
      jzbPerformedBy: row[29],
      nbuStatus: row[30],

      topSpeedAllowed: row[31],
      doorControlStatus: row[32],
      powerSupplyStatus: row[33],
      highSpeedCarsStatus: row[34],
    );
  }
}
