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

  // Export do CSV (sloupce musí sedět s fromCsvRow)
  List<String> toCsvRow() {
    return [
      trainName,                      // 0
      trainNumber,                    // 1
      maxSpeed,                       // 2
      trainLength,                    // 3
      trainCars.toString(),           // 4
      trainWheels,                    // 5
      brakeTypeD,                     // 6
      brakeTypeK,                     // 7
      brakeMode,                      // 8
      brakingModeP,                   // 9
      brakingModeR,                   // 10
      brakingModeRMg,                 // 11
      brakePercent,                   // 12
      brakingPercentageActual,        // 13
      brakingPercentageRequired,      // 14
      brakingPercentageMissing,       // 15
      activeVehiclesCount.toString(), // 16
      transportVehiclesCount.toString(), // 17
      totalVehiclesCount.toString(),     // 18
      activeVehiclesWeight.toString(),   // 19
      transportVehiclesWeight.toString(),// 20
      totalVehiclesWeight.toString(),    // 21
      departureStation,                // 22
      currentStation,                  // 23
      destinationStation,              // 24
      uzbLocation,                     // 25
      uzbPerformedBy,                  // 26
      jzbLocation,                     // 27
      jzbPerformedBy,                  // 28
      nbuStatus,                       // 29
      topSpeedAllowed,                 // 30
      doorControlStatus,               // 31
      powerSupplyStatus,               // 32
      highSpeedCarsStatus,             // 33
    ];
  }

  // Import z CSV
  factory ReportData.fromCsvRow(List<String> row) {
    return ReportData(
      trainName: row[0],
      trainNumber: row[1],
      maxSpeed: row[2],
      trainLength: row[3],
      trainCars: int.tryParse(row[4]) ?? 0,
      trainWheels: row[5],
      brakeTypeD: row[6],
      brakeTypeK: row[7],
      brakeMode: row[8],
      brakingModeP: row[9],
      brakingModeR: row[10],
      brakingModeRMg: row[11],
      brakePercent: row[12],
      brakingPercentageActual: row[13],
      brakingPercentageRequired: row[14],
      brakingPercentageMissing: row[15],
      activeVehiclesCount: int.tryParse(row[16]) ?? 0,
      transportVehiclesCount: int.tryParse(row[17]) ?? 0,
      totalVehiclesCount: int.tryParse(row[18]) ?? 0,
      activeVehiclesWeight: double.tryParse(row[19]) ?? 0.0,
      transportVehiclesWeight: double.tryParse(row[20]) ?? 0.0,
      totalVehiclesWeight: double.tryParse(row[21]) ?? 0.0,
      departureStation: row[22],
      currentStation: row[23],
      destinationStation: row[24],
      uzbLocation: row[25],
      uzbPerformedBy: row[26],
      jzbLocation: row[27],
      jzbPerformedBy: row[28],
      nbuStatus: row[29],
      topSpeedAllowed: row[30],
      doorControlStatus: row[31],
      powerSupplyStatus: row[32],
      highSpeedCarsStatus: row[33],
    );
  }
}
