// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TrainsTable extends Trains with TableInfo<$TrainsTable, Train> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _trainNameMeta = const VerificationMeta(
    'trainName',
  );
  @override
  late final GeneratedColumn<String> trainName = GeneratedColumn<String>(
    'trainName',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainNumberMeta = const VerificationMeta(
    'trainNumber',
  );
  @override
  late final GeneratedColumn<int> trainNumber = GeneratedColumn<int>(
    'trainNumber',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxSpeedMeta = const VerificationMeta(
    'maxSpeed',
  );
  @override
  late final GeneratedColumn<int> maxSpeed = GeneratedColumn<int>(
    'maxSpeed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainLengthMeta = const VerificationMeta(
    'trainLength',
  );
  @override
  late final GeneratedColumn<int> trainLength = GeneratedColumn<int>(
    'trainLength',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainCarsMeta = const VerificationMeta(
    'trainCars',
  );
  @override
  late final GeneratedColumn<int> trainCars = GeneratedColumn<int>(
    'trainCars',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainWheelsMeta = const VerificationMeta(
    'trainWheels',
  );
  @override
  late final GeneratedColumn<String> trainWheels = GeneratedColumn<String>(
    'trainWheels',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakeTypeDMeta = const VerificationMeta(
    'brakeTypeD',
  );
  @override
  late final GeneratedColumn<int> brakeTypeD = GeneratedColumn<int>(
    'brakeTypeD',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakeTypeKMeta = const VerificationMeta(
    'brakeTypeK',
  );
  @override
  late final GeneratedColumn<int> brakeTypeK = GeneratedColumn<int>(
    'brakeTypeK',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakeModeMeta = const VerificationMeta(
    'brakeMode',
  );
  @override
  late final GeneratedColumn<String> brakeMode = GeneratedColumn<String>(
    'brakeMode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakingModePMeta = const VerificationMeta(
    'brakingModeP',
  );
  @override
  late final GeneratedColumn<int> brakingModeP = GeneratedColumn<int>(
    'brakingModeP',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakingModeRMeta = const VerificationMeta(
    'brakingModeR',
  );
  @override
  late final GeneratedColumn<int> brakingModeR = GeneratedColumn<int>(
    'brakingModeR',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakingModeRMgMeta = const VerificationMeta(
    'brakingModeRMg',
  );
  @override
  late final GeneratedColumn<int> brakingModeRMg = GeneratedColumn<int>(
    'brakingModeRMg',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakePercentMeta = const VerificationMeta(
    'brakePercent',
  );
  @override
  late final GeneratedColumn<int> brakePercent = GeneratedColumn<int>(
    'brakePercent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakingPercentageActualMeta =
      const VerificationMeta('brakingPercentageActual');
  @override
  late final GeneratedColumn<int> brakingPercentageActual =
      GeneratedColumn<int>(
        'brakingPercentageActual',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _brakingPercentageRequiredMeta =
      const VerificationMeta('brakingPercentageRequired');
  @override
  late final GeneratedColumn<int> brakingPercentageRequired =
      GeneratedColumn<int>(
        'brakingPercentageRequired',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _brakingPercentageMissingMeta =
      const VerificationMeta('brakingPercentageMissing');
  @override
  late final GeneratedColumn<int> brakingPercentageMissing =
      GeneratedColumn<int>(
        'brakingPercentageMissing',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _activeVehiclesCountMeta =
      const VerificationMeta('activeVehiclesCount');
  @override
  late final GeneratedColumn<int> activeVehiclesCount = GeneratedColumn<int>(
    'activeVehiclesCount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transportVehiclesCountMeta =
      const VerificationMeta('transportVehiclesCount');
  @override
  late final GeneratedColumn<int> transportVehiclesCount = GeneratedColumn<int>(
    'transportVehiclesCount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalVehiclesCountMeta =
      const VerificationMeta('totalVehiclesCount');
  @override
  late final GeneratedColumn<int> totalVehiclesCount = GeneratedColumn<int>(
    'totalVehiclesCount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeVehiclesWeightMeta =
      const VerificationMeta('activeVehiclesWeight');
  @override
  late final GeneratedColumn<double> activeVehiclesWeight =
      GeneratedColumn<double>(
        'activeVehiclesWeight',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _transportVehiclesWeightMeta =
      const VerificationMeta('transportVehiclesWeight');
  @override
  late final GeneratedColumn<double> transportVehiclesWeight =
      GeneratedColumn<double>(
        'transportVehiclesWeight',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _totalVehiclesWeightMeta =
      const VerificationMeta('totalVehiclesWeight');
  @override
  late final GeneratedColumn<double> totalVehiclesWeight =
      GeneratedColumn<double>(
        'totalVehiclesWeight',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _departureStationMeta = const VerificationMeta(
    'departureStation',
  );
  @override
  late final GeneratedColumn<String> departureStation = GeneratedColumn<String>(
    'departureStation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentStationMeta = const VerificationMeta(
    'currentStation',
  );
  @override
  late final GeneratedColumn<String> currentStation = GeneratedColumn<String>(
    'currentStation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationStationMeta =
      const VerificationMeta('destinationStation');
  @override
  late final GeneratedColumn<String> destinationStation =
      GeneratedColumn<String>(
        'destinationStation',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _uzbLocationMeta = const VerificationMeta(
    'uzbLocation',
  );
  @override
  late final GeneratedColumn<String> uzbLocation = GeneratedColumn<String>(
    'uzbLocation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uzbPerformedByMeta = const VerificationMeta(
    'uzbPerformedBy',
  );
  @override
  late final GeneratedColumn<String> uzbPerformedBy = GeneratedColumn<String>(
    'uzbPerformedBy',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jzbLocationMeta = const VerificationMeta(
    'jzbLocation',
  );
  @override
  late final GeneratedColumn<String> jzbLocation = GeneratedColumn<String>(
    'jzbLocation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jzbPerformedByMeta = const VerificationMeta(
    'jzbPerformedBy',
  );
  @override
  late final GeneratedColumn<String> jzbPerformedBy = GeneratedColumn<String>(
    'jzbPerformedBy',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nbuStatusMeta = const VerificationMeta(
    'nbuStatus',
  );
  @override
  late final GeneratedColumn<String> nbuStatus = GeneratedColumn<String>(
    'nbuStatus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doorControlStatusMeta = const VerificationMeta(
    'doorControlStatus',
  );
  @override
  late final GeneratedColumn<String> doorControlStatus =
      GeneratedColumn<String>(
        'doorControlStatus',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _powerSupplyStatusMeta = const VerificationMeta(
    'powerSupplyStatus',
  );
  @override
  late final GeneratedColumn<String> powerSupplyStatus =
      GeneratedColumn<String>(
        'powerSupplyStatus',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _highSpeedCarsStatusMeta =
      const VerificationMeta('highSpeedCarsStatus');
  @override
  late final GeneratedColumn<String> highSpeedCarsStatus =
      GeneratedColumn<String>(
        'highSpeedCarsStatus',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _topSpeedAllowedMeta = const VerificationMeta(
    'topSpeedAllowed',
  );
  @override
  late final GeneratedColumn<double> topSpeedAllowed = GeneratedColumn<double>(
    'topSpeedAllowed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tjrFileNameMeta = const VerificationMeta(
    'tjrFileName',
  );
  @override
  late final GeneratedColumn<String> tjrFileName = GeneratedColumn<String>(
    'tjrFileName',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trainName,
    trainNumber,
    maxSpeed,
    trainLength,
    trainCars,
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
    activeVehiclesCount,
    transportVehiclesCount,
    totalVehiclesCount,
    activeVehiclesWeight,
    transportVehiclesWeight,
    totalVehiclesWeight,
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
    tjrFileName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trains';
  @override
  VerificationContext validateIntegrity(
    Insertable<Train> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trainName')) {
      context.handle(
        _trainNameMeta,
        trainName.isAcceptableOrUnknown(data['trainName']!, _trainNameMeta),
      );
    }
    if (data.containsKey('trainNumber')) {
      context.handle(
        _trainNumberMeta,
        trainNumber.isAcceptableOrUnknown(
          data['trainNumber']!,
          _trainNumberMeta,
        ),
      );
    }
    if (data.containsKey('maxSpeed')) {
      context.handle(
        _maxSpeedMeta,
        maxSpeed.isAcceptableOrUnknown(data['maxSpeed']!, _maxSpeedMeta),
      );
    }
    if (data.containsKey('trainLength')) {
      context.handle(
        _trainLengthMeta,
        trainLength.isAcceptableOrUnknown(
          data['trainLength']!,
          _trainLengthMeta,
        ),
      );
    }
    if (data.containsKey('trainCars')) {
      context.handle(
        _trainCarsMeta,
        trainCars.isAcceptableOrUnknown(data['trainCars']!, _trainCarsMeta),
      );
    }
    if (data.containsKey('trainWheels')) {
      context.handle(
        _trainWheelsMeta,
        trainWheels.isAcceptableOrUnknown(
          data['trainWheels']!,
          _trainWheelsMeta,
        ),
      );
    }
    if (data.containsKey('brakeTypeD')) {
      context.handle(
        _brakeTypeDMeta,
        brakeTypeD.isAcceptableOrUnknown(data['brakeTypeD']!, _brakeTypeDMeta),
      );
    }
    if (data.containsKey('brakeTypeK')) {
      context.handle(
        _brakeTypeKMeta,
        brakeTypeK.isAcceptableOrUnknown(data['brakeTypeK']!, _brakeTypeKMeta),
      );
    }
    if (data.containsKey('brakeMode')) {
      context.handle(
        _brakeModeMeta,
        brakeMode.isAcceptableOrUnknown(data['brakeMode']!, _brakeModeMeta),
      );
    }
    if (data.containsKey('brakingModeP')) {
      context.handle(
        _brakingModePMeta,
        brakingModeP.isAcceptableOrUnknown(
          data['brakingModeP']!,
          _brakingModePMeta,
        ),
      );
    }
    if (data.containsKey('brakingModeR')) {
      context.handle(
        _brakingModeRMeta,
        brakingModeR.isAcceptableOrUnknown(
          data['brakingModeR']!,
          _brakingModeRMeta,
        ),
      );
    }
    if (data.containsKey('brakingModeRMg')) {
      context.handle(
        _brakingModeRMgMeta,
        brakingModeRMg.isAcceptableOrUnknown(
          data['brakingModeRMg']!,
          _brakingModeRMgMeta,
        ),
      );
    }
    if (data.containsKey('brakePercent')) {
      context.handle(
        _brakePercentMeta,
        brakePercent.isAcceptableOrUnknown(
          data['brakePercent']!,
          _brakePercentMeta,
        ),
      );
    }
    if (data.containsKey('brakingPercentageActual')) {
      context.handle(
        _brakingPercentageActualMeta,
        brakingPercentageActual.isAcceptableOrUnknown(
          data['brakingPercentageActual']!,
          _brakingPercentageActualMeta,
        ),
      );
    }
    if (data.containsKey('brakingPercentageRequired')) {
      context.handle(
        _brakingPercentageRequiredMeta,
        brakingPercentageRequired.isAcceptableOrUnknown(
          data['brakingPercentageRequired']!,
          _brakingPercentageRequiredMeta,
        ),
      );
    }
    if (data.containsKey('brakingPercentageMissing')) {
      context.handle(
        _brakingPercentageMissingMeta,
        brakingPercentageMissing.isAcceptableOrUnknown(
          data['brakingPercentageMissing']!,
          _brakingPercentageMissingMeta,
        ),
      );
    }
    if (data.containsKey('activeVehiclesCount')) {
      context.handle(
        _activeVehiclesCountMeta,
        activeVehiclesCount.isAcceptableOrUnknown(
          data['activeVehiclesCount']!,
          _activeVehiclesCountMeta,
        ),
      );
    }
    if (data.containsKey('transportVehiclesCount')) {
      context.handle(
        _transportVehiclesCountMeta,
        transportVehiclesCount.isAcceptableOrUnknown(
          data['transportVehiclesCount']!,
          _transportVehiclesCountMeta,
        ),
      );
    }
    if (data.containsKey('totalVehiclesCount')) {
      context.handle(
        _totalVehiclesCountMeta,
        totalVehiclesCount.isAcceptableOrUnknown(
          data['totalVehiclesCount']!,
          _totalVehiclesCountMeta,
        ),
      );
    }
    if (data.containsKey('activeVehiclesWeight')) {
      context.handle(
        _activeVehiclesWeightMeta,
        activeVehiclesWeight.isAcceptableOrUnknown(
          data['activeVehiclesWeight']!,
          _activeVehiclesWeightMeta,
        ),
      );
    }
    if (data.containsKey('transportVehiclesWeight')) {
      context.handle(
        _transportVehiclesWeightMeta,
        transportVehiclesWeight.isAcceptableOrUnknown(
          data['transportVehiclesWeight']!,
          _transportVehiclesWeightMeta,
        ),
      );
    }
    if (data.containsKey('totalVehiclesWeight')) {
      context.handle(
        _totalVehiclesWeightMeta,
        totalVehiclesWeight.isAcceptableOrUnknown(
          data['totalVehiclesWeight']!,
          _totalVehiclesWeightMeta,
        ),
      );
    }
    if (data.containsKey('departureStation')) {
      context.handle(
        _departureStationMeta,
        departureStation.isAcceptableOrUnknown(
          data['departureStation']!,
          _departureStationMeta,
        ),
      );
    }
    if (data.containsKey('currentStation')) {
      context.handle(
        _currentStationMeta,
        currentStation.isAcceptableOrUnknown(
          data['currentStation']!,
          _currentStationMeta,
        ),
      );
    }
    if (data.containsKey('destinationStation')) {
      context.handle(
        _destinationStationMeta,
        destinationStation.isAcceptableOrUnknown(
          data['destinationStation']!,
          _destinationStationMeta,
        ),
      );
    }
    if (data.containsKey('uzbLocation')) {
      context.handle(
        _uzbLocationMeta,
        uzbLocation.isAcceptableOrUnknown(
          data['uzbLocation']!,
          _uzbLocationMeta,
        ),
      );
    }
    if (data.containsKey('uzbPerformedBy')) {
      context.handle(
        _uzbPerformedByMeta,
        uzbPerformedBy.isAcceptableOrUnknown(
          data['uzbPerformedBy']!,
          _uzbPerformedByMeta,
        ),
      );
    }
    if (data.containsKey('jzbLocation')) {
      context.handle(
        _jzbLocationMeta,
        jzbLocation.isAcceptableOrUnknown(
          data['jzbLocation']!,
          _jzbLocationMeta,
        ),
      );
    }
    if (data.containsKey('jzbPerformedBy')) {
      context.handle(
        _jzbPerformedByMeta,
        jzbPerformedBy.isAcceptableOrUnknown(
          data['jzbPerformedBy']!,
          _jzbPerformedByMeta,
        ),
      );
    }
    if (data.containsKey('nbuStatus')) {
      context.handle(
        _nbuStatusMeta,
        nbuStatus.isAcceptableOrUnknown(data['nbuStatus']!, _nbuStatusMeta),
      );
    }
    if (data.containsKey('doorControlStatus')) {
      context.handle(
        _doorControlStatusMeta,
        doorControlStatus.isAcceptableOrUnknown(
          data['doorControlStatus']!,
          _doorControlStatusMeta,
        ),
      );
    }
    if (data.containsKey('powerSupplyStatus')) {
      context.handle(
        _powerSupplyStatusMeta,
        powerSupplyStatus.isAcceptableOrUnknown(
          data['powerSupplyStatus']!,
          _powerSupplyStatusMeta,
        ),
      );
    }
    if (data.containsKey('highSpeedCarsStatus')) {
      context.handle(
        _highSpeedCarsStatusMeta,
        highSpeedCarsStatus.isAcceptableOrUnknown(
          data['highSpeedCarsStatus']!,
          _highSpeedCarsStatusMeta,
        ),
      );
    }
    if (data.containsKey('topSpeedAllowed')) {
      context.handle(
        _topSpeedAllowedMeta,
        topSpeedAllowed.isAcceptableOrUnknown(
          data['topSpeedAllowed']!,
          _topSpeedAllowedMeta,
        ),
      );
    }
    if (data.containsKey('tjrFileName')) {
      context.handle(
        _tjrFileNameMeta,
        tjrFileName.isAcceptableOrUnknown(
          data['tjrFileName']!,
          _tjrFileNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Train map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Train(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trainName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trainName'],
      ),
      trainNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trainNumber'],
      ),
      maxSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maxSpeed'],
      ),
      trainLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trainLength'],
      ),
      trainCars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trainCars'],
      ),
      trainWheels: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trainWheels'],
      ),
      brakeTypeD: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakeTypeD'],
      ),
      brakeTypeK: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakeTypeK'],
      ),
      brakeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brakeMode'],
      ),
      brakingModeP: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakingModeP'],
      ),
      brakingModeR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakingModeR'],
      ),
      brakingModeRMg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakingModeRMg'],
      ),
      brakePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakePercent'],
      ),
      brakingPercentageActual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakingPercentageActual'],
      ),
      brakingPercentageRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakingPercentageRequired'],
      ),
      brakingPercentageMissing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brakingPercentageMissing'],
      ),
      activeVehiclesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activeVehiclesCount'],
      ),
      transportVehiclesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transportVehiclesCount'],
      ),
      totalVehiclesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}totalVehiclesCount'],
      ),
      activeVehiclesWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}activeVehiclesWeight'],
      ),
      transportVehiclesWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}transportVehiclesWeight'],
      ),
      totalVehiclesWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}totalVehiclesWeight'],
      ),
      departureStation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departureStation'],
      ),
      currentStation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currentStation'],
      ),
      destinationStation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destinationStation'],
      ),
      uzbLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uzbLocation'],
      ),
      uzbPerformedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uzbPerformedBy'],
      ),
      jzbLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jzbLocation'],
      ),
      jzbPerformedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jzbPerformedBy'],
      ),
      nbuStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nbuStatus'],
      ),
      doorControlStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doorControlStatus'],
      ),
      powerSupplyStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}powerSupplyStatus'],
      ),
      highSpeedCarsStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}highSpeedCarsStatus'],
      ),
      topSpeedAllowed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}topSpeedAllowed'],
      ),
      tjrFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tjrFileName'],
      ),
    );
  }

  @override
  $TrainsTable createAlias(String alias) {
    return $TrainsTable(attachedDatabase, alias);
  }
}

class Train extends DataClass implements Insertable<Train> {
  final int id;
  final String? trainName;
  final int? trainNumber;
  final int? maxSpeed;
  final int? trainLength;
  final int? trainCars;
  final String? trainWheels;
  final int? brakeTypeD;
  final int? brakeTypeK;
  final String? brakeMode;
  final int? brakingModeP;
  final int? brakingModeR;
  final int? brakingModeRMg;
  final int? brakePercent;
  final int? brakingPercentageActual;
  final int? brakingPercentageRequired;
  final int? brakingPercentageMissing;
  final int? activeVehiclesCount;
  final int? transportVehiclesCount;
  final int? totalVehiclesCount;
  final double? activeVehiclesWeight;
  final double? transportVehiclesWeight;
  final double? totalVehiclesWeight;
  final String? departureStation;
  final String? currentStation;
  final String? destinationStation;
  final String? uzbLocation;
  final String? uzbPerformedBy;
  final String? jzbLocation;
  final String? jzbPerformedBy;
  final String? nbuStatus;
  final String? doorControlStatus;
  final String? powerSupplyStatus;
  final String? highSpeedCarsStatus;
  final double? topSpeedAllowed;
  final String? tjrFileName;
  const Train({
    required this.id,
    this.trainName,
    this.trainNumber,
    this.maxSpeed,
    this.trainLength,
    this.trainCars,
    this.trainWheels,
    this.brakeTypeD,
    this.brakeTypeK,
    this.brakeMode,
    this.brakingModeP,
    this.brakingModeR,
    this.brakingModeRMg,
    this.brakePercent,
    this.brakingPercentageActual,
    this.brakingPercentageRequired,
    this.brakingPercentageMissing,
    this.activeVehiclesCount,
    this.transportVehiclesCount,
    this.totalVehiclesCount,
    this.activeVehiclesWeight,
    this.transportVehiclesWeight,
    this.totalVehiclesWeight,
    this.departureStation,
    this.currentStation,
    this.destinationStation,
    this.uzbLocation,
    this.uzbPerformedBy,
    this.jzbLocation,
    this.jzbPerformedBy,
    this.nbuStatus,
    this.doorControlStatus,
    this.powerSupplyStatus,
    this.highSpeedCarsStatus,
    this.topSpeedAllowed,
    this.tjrFileName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || trainName != null) {
      map['trainName'] = Variable<String>(trainName);
    }
    if (!nullToAbsent || trainNumber != null) {
      map['trainNumber'] = Variable<int>(trainNumber);
    }
    if (!nullToAbsent || maxSpeed != null) {
      map['maxSpeed'] = Variable<int>(maxSpeed);
    }
    if (!nullToAbsent || trainLength != null) {
      map['trainLength'] = Variable<int>(trainLength);
    }
    if (!nullToAbsent || trainCars != null) {
      map['trainCars'] = Variable<int>(trainCars);
    }
    if (!nullToAbsent || trainWheels != null) {
      map['trainWheels'] = Variable<String>(trainWheels);
    }
    if (!nullToAbsent || brakeTypeD != null) {
      map['brakeTypeD'] = Variable<int>(brakeTypeD);
    }
    if (!nullToAbsent || brakeTypeK != null) {
      map['brakeTypeK'] = Variable<int>(brakeTypeK);
    }
    if (!nullToAbsent || brakeMode != null) {
      map['brakeMode'] = Variable<String>(brakeMode);
    }
    if (!nullToAbsent || brakingModeP != null) {
      map['brakingModeP'] = Variable<int>(brakingModeP);
    }
    if (!nullToAbsent || brakingModeR != null) {
      map['brakingModeR'] = Variable<int>(brakingModeR);
    }
    if (!nullToAbsent || brakingModeRMg != null) {
      map['brakingModeRMg'] = Variable<int>(brakingModeRMg);
    }
    if (!nullToAbsent || brakePercent != null) {
      map['brakePercent'] = Variable<int>(brakePercent);
    }
    if (!nullToAbsent || brakingPercentageActual != null) {
      map['brakingPercentageActual'] = Variable<int>(brakingPercentageActual);
    }
    if (!nullToAbsent || brakingPercentageRequired != null) {
      map['brakingPercentageRequired'] = Variable<int>(
        brakingPercentageRequired,
      );
    }
    if (!nullToAbsent || brakingPercentageMissing != null) {
      map['brakingPercentageMissing'] = Variable<int>(brakingPercentageMissing);
    }
    if (!nullToAbsent || activeVehiclesCount != null) {
      map['activeVehiclesCount'] = Variable<int>(activeVehiclesCount);
    }
    if (!nullToAbsent || transportVehiclesCount != null) {
      map['transportVehiclesCount'] = Variable<int>(transportVehiclesCount);
    }
    if (!nullToAbsent || totalVehiclesCount != null) {
      map['totalVehiclesCount'] = Variable<int>(totalVehiclesCount);
    }
    if (!nullToAbsent || activeVehiclesWeight != null) {
      map['activeVehiclesWeight'] = Variable<double>(activeVehiclesWeight);
    }
    if (!nullToAbsent || transportVehiclesWeight != null) {
      map['transportVehiclesWeight'] = Variable<double>(
        transportVehiclesWeight,
      );
    }
    if (!nullToAbsent || totalVehiclesWeight != null) {
      map['totalVehiclesWeight'] = Variable<double>(totalVehiclesWeight);
    }
    if (!nullToAbsent || departureStation != null) {
      map['departureStation'] = Variable<String>(departureStation);
    }
    if (!nullToAbsent || currentStation != null) {
      map['currentStation'] = Variable<String>(currentStation);
    }
    if (!nullToAbsent || destinationStation != null) {
      map['destinationStation'] = Variable<String>(destinationStation);
    }
    if (!nullToAbsent || uzbLocation != null) {
      map['uzbLocation'] = Variable<String>(uzbLocation);
    }
    if (!nullToAbsent || uzbPerformedBy != null) {
      map['uzbPerformedBy'] = Variable<String>(uzbPerformedBy);
    }
    if (!nullToAbsent || jzbLocation != null) {
      map['jzbLocation'] = Variable<String>(jzbLocation);
    }
    if (!nullToAbsent || jzbPerformedBy != null) {
      map['jzbPerformedBy'] = Variable<String>(jzbPerformedBy);
    }
    if (!nullToAbsent || nbuStatus != null) {
      map['nbuStatus'] = Variable<String>(nbuStatus);
    }
    if (!nullToAbsent || doorControlStatus != null) {
      map['doorControlStatus'] = Variable<String>(doorControlStatus);
    }
    if (!nullToAbsent || powerSupplyStatus != null) {
      map['powerSupplyStatus'] = Variable<String>(powerSupplyStatus);
    }
    if (!nullToAbsent || highSpeedCarsStatus != null) {
      map['highSpeedCarsStatus'] = Variable<String>(highSpeedCarsStatus);
    }
    if (!nullToAbsent || topSpeedAllowed != null) {
      map['topSpeedAllowed'] = Variable<double>(topSpeedAllowed);
    }
    if (!nullToAbsent || tjrFileName != null) {
      map['tjrFileName'] = Variable<String>(tjrFileName);
    }
    return map;
  }

  TrainsCompanion toCompanion(bool nullToAbsent) {
    return TrainsCompanion(
      id: Value(id),
      trainName: trainName == null && nullToAbsent
          ? const Value.absent()
          : Value(trainName),
      trainNumber: trainNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trainNumber),
      maxSpeed: maxSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSpeed),
      trainLength: trainLength == null && nullToAbsent
          ? const Value.absent()
          : Value(trainLength),
      trainCars: trainCars == null && nullToAbsent
          ? const Value.absent()
          : Value(trainCars),
      trainWheels: trainWheels == null && nullToAbsent
          ? const Value.absent()
          : Value(trainWheels),
      brakeTypeD: brakeTypeD == null && nullToAbsent
          ? const Value.absent()
          : Value(brakeTypeD),
      brakeTypeK: brakeTypeK == null && nullToAbsent
          ? const Value.absent()
          : Value(brakeTypeK),
      brakeMode: brakeMode == null && nullToAbsent
          ? const Value.absent()
          : Value(brakeMode),
      brakingModeP: brakingModeP == null && nullToAbsent
          ? const Value.absent()
          : Value(brakingModeP),
      brakingModeR: brakingModeR == null && nullToAbsent
          ? const Value.absent()
          : Value(brakingModeR),
      brakingModeRMg: brakingModeRMg == null && nullToAbsent
          ? const Value.absent()
          : Value(brakingModeRMg),
      brakePercent: brakePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(brakePercent),
      brakingPercentageActual: brakingPercentageActual == null && nullToAbsent
          ? const Value.absent()
          : Value(brakingPercentageActual),
      brakingPercentageRequired:
          brakingPercentageRequired == null && nullToAbsent
          ? const Value.absent()
          : Value(brakingPercentageRequired),
      brakingPercentageMissing: brakingPercentageMissing == null && nullToAbsent
          ? const Value.absent()
          : Value(brakingPercentageMissing),
      activeVehiclesCount: activeVehiclesCount == null && nullToAbsent
          ? const Value.absent()
          : Value(activeVehiclesCount),
      transportVehiclesCount: transportVehiclesCount == null && nullToAbsent
          ? const Value.absent()
          : Value(transportVehiclesCount),
      totalVehiclesCount: totalVehiclesCount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalVehiclesCount),
      activeVehiclesWeight: activeVehiclesWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(activeVehiclesWeight),
      transportVehiclesWeight: transportVehiclesWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(transportVehiclesWeight),
      totalVehiclesWeight: totalVehiclesWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(totalVehiclesWeight),
      departureStation: departureStation == null && nullToAbsent
          ? const Value.absent()
          : Value(departureStation),
      currentStation: currentStation == null && nullToAbsent
          ? const Value.absent()
          : Value(currentStation),
      destinationStation: destinationStation == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationStation),
      uzbLocation: uzbLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(uzbLocation),
      uzbPerformedBy: uzbPerformedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(uzbPerformedBy),
      jzbLocation: jzbLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(jzbLocation),
      jzbPerformedBy: jzbPerformedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(jzbPerformedBy),
      nbuStatus: nbuStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(nbuStatus),
      doorControlStatus: doorControlStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(doorControlStatus),
      powerSupplyStatus: powerSupplyStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(powerSupplyStatus),
      highSpeedCarsStatus: highSpeedCarsStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(highSpeedCarsStatus),
      topSpeedAllowed: topSpeedAllowed == null && nullToAbsent
          ? const Value.absent()
          : Value(topSpeedAllowed),
      tjrFileName: tjrFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(tjrFileName),
    );
  }

  factory Train.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Train(
      id: serializer.fromJson<int>(json['id']),
      trainName: serializer.fromJson<String?>(json['trainName']),
      trainNumber: serializer.fromJson<int?>(json['trainNumber']),
      maxSpeed: serializer.fromJson<int?>(json['maxSpeed']),
      trainLength: serializer.fromJson<int?>(json['trainLength']),
      trainCars: serializer.fromJson<int?>(json['trainCars']),
      trainWheels: serializer.fromJson<String?>(json['trainWheels']),
      brakeTypeD: serializer.fromJson<int?>(json['brakeTypeD']),
      brakeTypeK: serializer.fromJson<int?>(json['brakeTypeK']),
      brakeMode: serializer.fromJson<String?>(json['brakeMode']),
      brakingModeP: serializer.fromJson<int?>(json['brakingModeP']),
      brakingModeR: serializer.fromJson<int?>(json['brakingModeR']),
      brakingModeRMg: serializer.fromJson<int?>(json['brakingModeRMg']),
      brakePercent: serializer.fromJson<int?>(json['brakePercent']),
      brakingPercentageActual: serializer.fromJson<int?>(
        json['brakingPercentageActual'],
      ),
      brakingPercentageRequired: serializer.fromJson<int?>(
        json['brakingPercentageRequired'],
      ),
      brakingPercentageMissing: serializer.fromJson<int?>(
        json['brakingPercentageMissing'],
      ),
      activeVehiclesCount: serializer.fromJson<int?>(
        json['activeVehiclesCount'],
      ),
      transportVehiclesCount: serializer.fromJson<int?>(
        json['transportVehiclesCount'],
      ),
      totalVehiclesCount: serializer.fromJson<int?>(json['totalVehiclesCount']),
      activeVehiclesWeight: serializer.fromJson<double?>(
        json['activeVehiclesWeight'],
      ),
      transportVehiclesWeight: serializer.fromJson<double?>(
        json['transportVehiclesWeight'],
      ),
      totalVehiclesWeight: serializer.fromJson<double?>(
        json['totalVehiclesWeight'],
      ),
      departureStation: serializer.fromJson<String?>(json['departureStation']),
      currentStation: serializer.fromJson<String?>(json['currentStation']),
      destinationStation: serializer.fromJson<String?>(
        json['destinationStation'],
      ),
      uzbLocation: serializer.fromJson<String?>(json['uzbLocation']),
      uzbPerformedBy: serializer.fromJson<String?>(json['uzbPerformedBy']),
      jzbLocation: serializer.fromJson<String?>(json['jzbLocation']),
      jzbPerformedBy: serializer.fromJson<String?>(json['jzbPerformedBy']),
      nbuStatus: serializer.fromJson<String?>(json['nbuStatus']),
      doorControlStatus: serializer.fromJson<String?>(
        json['doorControlStatus'],
      ),
      powerSupplyStatus: serializer.fromJson<String?>(
        json['powerSupplyStatus'],
      ),
      highSpeedCarsStatus: serializer.fromJson<String?>(
        json['highSpeedCarsStatus'],
      ),
      topSpeedAllowed: serializer.fromJson<double?>(json['topSpeedAllowed']),
      tjrFileName: serializer.fromJson<String?>(json['tjrFileName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trainName': serializer.toJson<String?>(trainName),
      'trainNumber': serializer.toJson<int?>(trainNumber),
      'maxSpeed': serializer.toJson<int?>(maxSpeed),
      'trainLength': serializer.toJson<int?>(trainLength),
      'trainCars': serializer.toJson<int?>(trainCars),
      'trainWheels': serializer.toJson<String?>(trainWheels),
      'brakeTypeD': serializer.toJson<int?>(brakeTypeD),
      'brakeTypeK': serializer.toJson<int?>(brakeTypeK),
      'brakeMode': serializer.toJson<String?>(brakeMode),
      'brakingModeP': serializer.toJson<int?>(brakingModeP),
      'brakingModeR': serializer.toJson<int?>(brakingModeR),
      'brakingModeRMg': serializer.toJson<int?>(brakingModeRMg),
      'brakePercent': serializer.toJson<int?>(brakePercent),
      'brakingPercentageActual': serializer.toJson<int?>(
        brakingPercentageActual,
      ),
      'brakingPercentageRequired': serializer.toJson<int?>(
        brakingPercentageRequired,
      ),
      'brakingPercentageMissing': serializer.toJson<int?>(
        brakingPercentageMissing,
      ),
      'activeVehiclesCount': serializer.toJson<int?>(activeVehiclesCount),
      'transportVehiclesCount': serializer.toJson<int?>(transportVehiclesCount),
      'totalVehiclesCount': serializer.toJson<int?>(totalVehiclesCount),
      'activeVehiclesWeight': serializer.toJson<double?>(activeVehiclesWeight),
      'transportVehiclesWeight': serializer.toJson<double?>(
        transportVehiclesWeight,
      ),
      'totalVehiclesWeight': serializer.toJson<double?>(totalVehiclesWeight),
      'departureStation': serializer.toJson<String?>(departureStation),
      'currentStation': serializer.toJson<String?>(currentStation),
      'destinationStation': serializer.toJson<String?>(destinationStation),
      'uzbLocation': serializer.toJson<String?>(uzbLocation),
      'uzbPerformedBy': serializer.toJson<String?>(uzbPerformedBy),
      'jzbLocation': serializer.toJson<String?>(jzbLocation),
      'jzbPerformedBy': serializer.toJson<String?>(jzbPerformedBy),
      'nbuStatus': serializer.toJson<String?>(nbuStatus),
      'doorControlStatus': serializer.toJson<String?>(doorControlStatus),
      'powerSupplyStatus': serializer.toJson<String?>(powerSupplyStatus),
      'highSpeedCarsStatus': serializer.toJson<String?>(highSpeedCarsStatus),
      'topSpeedAllowed': serializer.toJson<double?>(topSpeedAllowed),
      'tjrFileName': serializer.toJson<String?>(tjrFileName),
    };
  }

  Train copyWith({
    int? id,
    Value<String?> trainName = const Value.absent(),
    Value<int?> trainNumber = const Value.absent(),
    Value<int?> maxSpeed = const Value.absent(),
    Value<int?> trainLength = const Value.absent(),
    Value<int?> trainCars = const Value.absent(),
    Value<String?> trainWheels = const Value.absent(),
    Value<int?> brakeTypeD = const Value.absent(),
    Value<int?> brakeTypeK = const Value.absent(),
    Value<String?> brakeMode = const Value.absent(),
    Value<int?> brakingModeP = const Value.absent(),
    Value<int?> brakingModeR = const Value.absent(),
    Value<int?> brakingModeRMg = const Value.absent(),
    Value<int?> brakePercent = const Value.absent(),
    Value<int?> brakingPercentageActual = const Value.absent(),
    Value<int?> brakingPercentageRequired = const Value.absent(),
    Value<int?> brakingPercentageMissing = const Value.absent(),
    Value<int?> activeVehiclesCount = const Value.absent(),
    Value<int?> transportVehiclesCount = const Value.absent(),
    Value<int?> totalVehiclesCount = const Value.absent(),
    Value<double?> activeVehiclesWeight = const Value.absent(),
    Value<double?> transportVehiclesWeight = const Value.absent(),
    Value<double?> totalVehiclesWeight = const Value.absent(),
    Value<String?> departureStation = const Value.absent(),
    Value<String?> currentStation = const Value.absent(),
    Value<String?> destinationStation = const Value.absent(),
    Value<String?> uzbLocation = const Value.absent(),
    Value<String?> uzbPerformedBy = const Value.absent(),
    Value<String?> jzbLocation = const Value.absent(),
    Value<String?> jzbPerformedBy = const Value.absent(),
    Value<String?> nbuStatus = const Value.absent(),
    Value<String?> doorControlStatus = const Value.absent(),
    Value<String?> powerSupplyStatus = const Value.absent(),
    Value<String?> highSpeedCarsStatus = const Value.absent(),
    Value<double?> topSpeedAllowed = const Value.absent(),
    Value<String?> tjrFileName = const Value.absent(),
  }) => Train(
    id: id ?? this.id,
    trainName: trainName.present ? trainName.value : this.trainName,
    trainNumber: trainNumber.present ? trainNumber.value : this.trainNumber,
    maxSpeed: maxSpeed.present ? maxSpeed.value : this.maxSpeed,
    trainLength: trainLength.present ? trainLength.value : this.trainLength,
    trainCars: trainCars.present ? trainCars.value : this.trainCars,
    trainWheels: trainWheels.present ? trainWheels.value : this.trainWheels,
    brakeTypeD: brakeTypeD.present ? brakeTypeD.value : this.brakeTypeD,
    brakeTypeK: brakeTypeK.present ? brakeTypeK.value : this.brakeTypeK,
    brakeMode: brakeMode.present ? brakeMode.value : this.brakeMode,
    brakingModeP: brakingModeP.present ? brakingModeP.value : this.brakingModeP,
    brakingModeR: brakingModeR.present ? brakingModeR.value : this.brakingModeR,
    brakingModeRMg: brakingModeRMg.present
        ? brakingModeRMg.value
        : this.brakingModeRMg,
    brakePercent: brakePercent.present ? brakePercent.value : this.brakePercent,
    brakingPercentageActual: brakingPercentageActual.present
        ? brakingPercentageActual.value
        : this.brakingPercentageActual,
    brakingPercentageRequired: brakingPercentageRequired.present
        ? brakingPercentageRequired.value
        : this.brakingPercentageRequired,
    brakingPercentageMissing: brakingPercentageMissing.present
        ? brakingPercentageMissing.value
        : this.brakingPercentageMissing,
    activeVehiclesCount: activeVehiclesCount.present
        ? activeVehiclesCount.value
        : this.activeVehiclesCount,
    transportVehiclesCount: transportVehiclesCount.present
        ? transportVehiclesCount.value
        : this.transportVehiclesCount,
    totalVehiclesCount: totalVehiclesCount.present
        ? totalVehiclesCount.value
        : this.totalVehiclesCount,
    activeVehiclesWeight: activeVehiclesWeight.present
        ? activeVehiclesWeight.value
        : this.activeVehiclesWeight,
    transportVehiclesWeight: transportVehiclesWeight.present
        ? transportVehiclesWeight.value
        : this.transportVehiclesWeight,
    totalVehiclesWeight: totalVehiclesWeight.present
        ? totalVehiclesWeight.value
        : this.totalVehiclesWeight,
    departureStation: departureStation.present
        ? departureStation.value
        : this.departureStation,
    currentStation: currentStation.present
        ? currentStation.value
        : this.currentStation,
    destinationStation: destinationStation.present
        ? destinationStation.value
        : this.destinationStation,
    uzbLocation: uzbLocation.present ? uzbLocation.value : this.uzbLocation,
    uzbPerformedBy: uzbPerformedBy.present
        ? uzbPerformedBy.value
        : this.uzbPerformedBy,
    jzbLocation: jzbLocation.present ? jzbLocation.value : this.jzbLocation,
    jzbPerformedBy: jzbPerformedBy.present
        ? jzbPerformedBy.value
        : this.jzbPerformedBy,
    nbuStatus: nbuStatus.present ? nbuStatus.value : this.nbuStatus,
    doorControlStatus: doorControlStatus.present
        ? doorControlStatus.value
        : this.doorControlStatus,
    powerSupplyStatus: powerSupplyStatus.present
        ? powerSupplyStatus.value
        : this.powerSupplyStatus,
    highSpeedCarsStatus: highSpeedCarsStatus.present
        ? highSpeedCarsStatus.value
        : this.highSpeedCarsStatus,
    topSpeedAllowed: topSpeedAllowed.present
        ? topSpeedAllowed.value
        : this.topSpeedAllowed,
    tjrFileName: tjrFileName.present ? tjrFileName.value : this.tjrFileName,
  );
  Train copyWithCompanion(TrainsCompanion data) {
    return Train(
      id: data.id.present ? data.id.value : this.id,
      trainName: data.trainName.present ? data.trainName.value : this.trainName,
      trainNumber: data.trainNumber.present
          ? data.trainNumber.value
          : this.trainNumber,
      maxSpeed: data.maxSpeed.present ? data.maxSpeed.value : this.maxSpeed,
      trainLength: data.trainLength.present
          ? data.trainLength.value
          : this.trainLength,
      trainCars: data.trainCars.present ? data.trainCars.value : this.trainCars,
      trainWheels: data.trainWheels.present
          ? data.trainWheels.value
          : this.trainWheels,
      brakeTypeD: data.brakeTypeD.present
          ? data.brakeTypeD.value
          : this.brakeTypeD,
      brakeTypeK: data.brakeTypeK.present
          ? data.brakeTypeK.value
          : this.brakeTypeK,
      brakeMode: data.brakeMode.present ? data.brakeMode.value : this.brakeMode,
      brakingModeP: data.brakingModeP.present
          ? data.brakingModeP.value
          : this.brakingModeP,
      brakingModeR: data.brakingModeR.present
          ? data.brakingModeR.value
          : this.brakingModeR,
      brakingModeRMg: data.brakingModeRMg.present
          ? data.brakingModeRMg.value
          : this.brakingModeRMg,
      brakePercent: data.brakePercent.present
          ? data.brakePercent.value
          : this.brakePercent,
      brakingPercentageActual: data.brakingPercentageActual.present
          ? data.brakingPercentageActual.value
          : this.brakingPercentageActual,
      brakingPercentageRequired: data.brakingPercentageRequired.present
          ? data.brakingPercentageRequired.value
          : this.brakingPercentageRequired,
      brakingPercentageMissing: data.brakingPercentageMissing.present
          ? data.brakingPercentageMissing.value
          : this.brakingPercentageMissing,
      activeVehiclesCount: data.activeVehiclesCount.present
          ? data.activeVehiclesCount.value
          : this.activeVehiclesCount,
      transportVehiclesCount: data.transportVehiclesCount.present
          ? data.transportVehiclesCount.value
          : this.transportVehiclesCount,
      totalVehiclesCount: data.totalVehiclesCount.present
          ? data.totalVehiclesCount.value
          : this.totalVehiclesCount,
      activeVehiclesWeight: data.activeVehiclesWeight.present
          ? data.activeVehiclesWeight.value
          : this.activeVehiclesWeight,
      transportVehiclesWeight: data.transportVehiclesWeight.present
          ? data.transportVehiclesWeight.value
          : this.transportVehiclesWeight,
      totalVehiclesWeight: data.totalVehiclesWeight.present
          ? data.totalVehiclesWeight.value
          : this.totalVehiclesWeight,
      departureStation: data.departureStation.present
          ? data.departureStation.value
          : this.departureStation,
      currentStation: data.currentStation.present
          ? data.currentStation.value
          : this.currentStation,
      destinationStation: data.destinationStation.present
          ? data.destinationStation.value
          : this.destinationStation,
      uzbLocation: data.uzbLocation.present
          ? data.uzbLocation.value
          : this.uzbLocation,
      uzbPerformedBy: data.uzbPerformedBy.present
          ? data.uzbPerformedBy.value
          : this.uzbPerformedBy,
      jzbLocation: data.jzbLocation.present
          ? data.jzbLocation.value
          : this.jzbLocation,
      jzbPerformedBy: data.jzbPerformedBy.present
          ? data.jzbPerformedBy.value
          : this.jzbPerformedBy,
      nbuStatus: data.nbuStatus.present ? data.nbuStatus.value : this.nbuStatus,
      doorControlStatus: data.doorControlStatus.present
          ? data.doorControlStatus.value
          : this.doorControlStatus,
      powerSupplyStatus: data.powerSupplyStatus.present
          ? data.powerSupplyStatus.value
          : this.powerSupplyStatus,
      highSpeedCarsStatus: data.highSpeedCarsStatus.present
          ? data.highSpeedCarsStatus.value
          : this.highSpeedCarsStatus,
      topSpeedAllowed: data.topSpeedAllowed.present
          ? data.topSpeedAllowed.value
          : this.topSpeedAllowed,
      tjrFileName: data.tjrFileName.present
          ? data.tjrFileName.value
          : this.tjrFileName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Train(')
          ..write('id: $id, ')
          ..write('trainName: $trainName, ')
          ..write('trainNumber: $trainNumber, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('trainLength: $trainLength, ')
          ..write('trainCars: $trainCars, ')
          ..write('trainWheels: $trainWheels, ')
          ..write('brakeTypeD: $brakeTypeD, ')
          ..write('brakeTypeK: $brakeTypeK, ')
          ..write('brakeMode: $brakeMode, ')
          ..write('brakingModeP: $brakingModeP, ')
          ..write('brakingModeR: $brakingModeR, ')
          ..write('brakingModeRMg: $brakingModeRMg, ')
          ..write('brakePercent: $brakePercent, ')
          ..write('brakingPercentageActual: $brakingPercentageActual, ')
          ..write('brakingPercentageRequired: $brakingPercentageRequired, ')
          ..write('brakingPercentageMissing: $brakingPercentageMissing, ')
          ..write('activeVehiclesCount: $activeVehiclesCount, ')
          ..write('transportVehiclesCount: $transportVehiclesCount, ')
          ..write('totalVehiclesCount: $totalVehiclesCount, ')
          ..write('activeVehiclesWeight: $activeVehiclesWeight, ')
          ..write('transportVehiclesWeight: $transportVehiclesWeight, ')
          ..write('totalVehiclesWeight: $totalVehiclesWeight, ')
          ..write('departureStation: $departureStation, ')
          ..write('currentStation: $currentStation, ')
          ..write('destinationStation: $destinationStation, ')
          ..write('uzbLocation: $uzbLocation, ')
          ..write('uzbPerformedBy: $uzbPerformedBy, ')
          ..write('jzbLocation: $jzbLocation, ')
          ..write('jzbPerformedBy: $jzbPerformedBy, ')
          ..write('nbuStatus: $nbuStatus, ')
          ..write('doorControlStatus: $doorControlStatus, ')
          ..write('powerSupplyStatus: $powerSupplyStatus, ')
          ..write('highSpeedCarsStatus: $highSpeedCarsStatus, ')
          ..write('topSpeedAllowed: $topSpeedAllowed, ')
          ..write('tjrFileName: $tjrFileName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    trainName,
    trainNumber,
    maxSpeed,
    trainLength,
    trainCars,
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
    activeVehiclesCount,
    transportVehiclesCount,
    totalVehiclesCount,
    activeVehiclesWeight,
    transportVehiclesWeight,
    totalVehiclesWeight,
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
    tjrFileName,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Train &&
          other.id == this.id &&
          other.trainName == this.trainName &&
          other.trainNumber == this.trainNumber &&
          other.maxSpeed == this.maxSpeed &&
          other.trainLength == this.trainLength &&
          other.trainCars == this.trainCars &&
          other.trainWheels == this.trainWheels &&
          other.brakeTypeD == this.brakeTypeD &&
          other.brakeTypeK == this.brakeTypeK &&
          other.brakeMode == this.brakeMode &&
          other.brakingModeP == this.brakingModeP &&
          other.brakingModeR == this.brakingModeR &&
          other.brakingModeRMg == this.brakingModeRMg &&
          other.brakePercent == this.brakePercent &&
          other.brakingPercentageActual == this.brakingPercentageActual &&
          other.brakingPercentageRequired == this.brakingPercentageRequired &&
          other.brakingPercentageMissing == this.brakingPercentageMissing &&
          other.activeVehiclesCount == this.activeVehiclesCount &&
          other.transportVehiclesCount == this.transportVehiclesCount &&
          other.totalVehiclesCount == this.totalVehiclesCount &&
          other.activeVehiclesWeight == this.activeVehiclesWeight &&
          other.transportVehiclesWeight == this.transportVehiclesWeight &&
          other.totalVehiclesWeight == this.totalVehiclesWeight &&
          other.departureStation == this.departureStation &&
          other.currentStation == this.currentStation &&
          other.destinationStation == this.destinationStation &&
          other.uzbLocation == this.uzbLocation &&
          other.uzbPerformedBy == this.uzbPerformedBy &&
          other.jzbLocation == this.jzbLocation &&
          other.jzbPerformedBy == this.jzbPerformedBy &&
          other.nbuStatus == this.nbuStatus &&
          other.doorControlStatus == this.doorControlStatus &&
          other.powerSupplyStatus == this.powerSupplyStatus &&
          other.highSpeedCarsStatus == this.highSpeedCarsStatus &&
          other.topSpeedAllowed == this.topSpeedAllowed &&
          other.tjrFileName == this.tjrFileName);
}

class TrainsCompanion extends UpdateCompanion<Train> {
  final Value<int> id;
  final Value<String?> trainName;
  final Value<int?> trainNumber;
  final Value<int?> maxSpeed;
  final Value<int?> trainLength;
  final Value<int?> trainCars;
  final Value<String?> trainWheels;
  final Value<int?> brakeTypeD;
  final Value<int?> brakeTypeK;
  final Value<String?> brakeMode;
  final Value<int?> brakingModeP;
  final Value<int?> brakingModeR;
  final Value<int?> brakingModeRMg;
  final Value<int?> brakePercent;
  final Value<int?> brakingPercentageActual;
  final Value<int?> brakingPercentageRequired;
  final Value<int?> brakingPercentageMissing;
  final Value<int?> activeVehiclesCount;
  final Value<int?> transportVehiclesCount;
  final Value<int?> totalVehiclesCount;
  final Value<double?> activeVehiclesWeight;
  final Value<double?> transportVehiclesWeight;
  final Value<double?> totalVehiclesWeight;
  final Value<String?> departureStation;
  final Value<String?> currentStation;
  final Value<String?> destinationStation;
  final Value<String?> uzbLocation;
  final Value<String?> uzbPerformedBy;
  final Value<String?> jzbLocation;
  final Value<String?> jzbPerformedBy;
  final Value<String?> nbuStatus;
  final Value<String?> doorControlStatus;
  final Value<String?> powerSupplyStatus;
  final Value<String?> highSpeedCarsStatus;
  final Value<double?> topSpeedAllowed;
  final Value<String?> tjrFileName;
  const TrainsCompanion({
    this.id = const Value.absent(),
    this.trainName = const Value.absent(),
    this.trainNumber = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.trainLength = const Value.absent(),
    this.trainCars = const Value.absent(),
    this.trainWheels = const Value.absent(),
    this.brakeTypeD = const Value.absent(),
    this.brakeTypeK = const Value.absent(),
    this.brakeMode = const Value.absent(),
    this.brakingModeP = const Value.absent(),
    this.brakingModeR = const Value.absent(),
    this.brakingModeRMg = const Value.absent(),
    this.brakePercent = const Value.absent(),
    this.brakingPercentageActual = const Value.absent(),
    this.brakingPercentageRequired = const Value.absent(),
    this.brakingPercentageMissing = const Value.absent(),
    this.activeVehiclesCount = const Value.absent(),
    this.transportVehiclesCount = const Value.absent(),
    this.totalVehiclesCount = const Value.absent(),
    this.activeVehiclesWeight = const Value.absent(),
    this.transportVehiclesWeight = const Value.absent(),
    this.totalVehiclesWeight = const Value.absent(),
    this.departureStation = const Value.absent(),
    this.currentStation = const Value.absent(),
    this.destinationStation = const Value.absent(),
    this.uzbLocation = const Value.absent(),
    this.uzbPerformedBy = const Value.absent(),
    this.jzbLocation = const Value.absent(),
    this.jzbPerformedBy = const Value.absent(),
    this.nbuStatus = const Value.absent(),
    this.doorControlStatus = const Value.absent(),
    this.powerSupplyStatus = const Value.absent(),
    this.highSpeedCarsStatus = const Value.absent(),
    this.topSpeedAllowed = const Value.absent(),
    this.tjrFileName = const Value.absent(),
  });
  TrainsCompanion.insert({
    this.id = const Value.absent(),
    this.trainName = const Value.absent(),
    this.trainNumber = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.trainLength = const Value.absent(),
    this.trainCars = const Value.absent(),
    this.trainWheels = const Value.absent(),
    this.brakeTypeD = const Value.absent(),
    this.brakeTypeK = const Value.absent(),
    this.brakeMode = const Value.absent(),
    this.brakingModeP = const Value.absent(),
    this.brakingModeR = const Value.absent(),
    this.brakingModeRMg = const Value.absent(),
    this.brakePercent = const Value.absent(),
    this.brakingPercentageActual = const Value.absent(),
    this.brakingPercentageRequired = const Value.absent(),
    this.brakingPercentageMissing = const Value.absent(),
    this.activeVehiclesCount = const Value.absent(),
    this.transportVehiclesCount = const Value.absent(),
    this.totalVehiclesCount = const Value.absent(),
    this.activeVehiclesWeight = const Value.absent(),
    this.transportVehiclesWeight = const Value.absent(),
    this.totalVehiclesWeight = const Value.absent(),
    this.departureStation = const Value.absent(),
    this.currentStation = const Value.absent(),
    this.destinationStation = const Value.absent(),
    this.uzbLocation = const Value.absent(),
    this.uzbPerformedBy = const Value.absent(),
    this.jzbLocation = const Value.absent(),
    this.jzbPerformedBy = const Value.absent(),
    this.nbuStatus = const Value.absent(),
    this.doorControlStatus = const Value.absent(),
    this.powerSupplyStatus = const Value.absent(),
    this.highSpeedCarsStatus = const Value.absent(),
    this.topSpeedAllowed = const Value.absent(),
    this.tjrFileName = const Value.absent(),
  });
  static Insertable<Train> custom({
    Expression<int>? id,
    Expression<String>? trainName,
    Expression<int>? trainNumber,
    Expression<int>? maxSpeed,
    Expression<int>? trainLength,
    Expression<int>? trainCars,
    Expression<String>? trainWheels,
    Expression<int>? brakeTypeD,
    Expression<int>? brakeTypeK,
    Expression<String>? brakeMode,
    Expression<int>? brakingModeP,
    Expression<int>? brakingModeR,
    Expression<int>? brakingModeRMg,
    Expression<int>? brakePercent,
    Expression<int>? brakingPercentageActual,
    Expression<int>? brakingPercentageRequired,
    Expression<int>? brakingPercentageMissing,
    Expression<int>? activeVehiclesCount,
    Expression<int>? transportVehiclesCount,
    Expression<int>? totalVehiclesCount,
    Expression<double>? activeVehiclesWeight,
    Expression<double>? transportVehiclesWeight,
    Expression<double>? totalVehiclesWeight,
    Expression<String>? departureStation,
    Expression<String>? currentStation,
    Expression<String>? destinationStation,
    Expression<String>? uzbLocation,
    Expression<String>? uzbPerformedBy,
    Expression<String>? jzbLocation,
    Expression<String>? jzbPerformedBy,
    Expression<String>? nbuStatus,
    Expression<String>? doorControlStatus,
    Expression<String>? powerSupplyStatus,
    Expression<String>? highSpeedCarsStatus,
    Expression<double>? topSpeedAllowed,
    Expression<String>? tjrFileName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trainName != null) 'trainName': trainName,
      if (trainNumber != null) 'trainNumber': trainNumber,
      if (maxSpeed != null) 'maxSpeed': maxSpeed,
      if (trainLength != null) 'trainLength': trainLength,
      if (trainCars != null) 'trainCars': trainCars,
      if (trainWheels != null) 'trainWheels': trainWheels,
      if (brakeTypeD != null) 'brakeTypeD': brakeTypeD,
      if (brakeTypeK != null) 'brakeTypeK': brakeTypeK,
      if (brakeMode != null) 'brakeMode': brakeMode,
      if (brakingModeP != null) 'brakingModeP': brakingModeP,
      if (brakingModeR != null) 'brakingModeR': brakingModeR,
      if (brakingModeRMg != null) 'brakingModeRMg': brakingModeRMg,
      if (brakePercent != null) 'brakePercent': brakePercent,
      if (brakingPercentageActual != null)
        'brakingPercentageActual': brakingPercentageActual,
      if (brakingPercentageRequired != null)
        'brakingPercentageRequired': brakingPercentageRequired,
      if (brakingPercentageMissing != null)
        'brakingPercentageMissing': brakingPercentageMissing,
      if (activeVehiclesCount != null)
        'activeVehiclesCount': activeVehiclesCount,
      if (transportVehiclesCount != null)
        'transportVehiclesCount': transportVehiclesCount,
      if (totalVehiclesCount != null) 'totalVehiclesCount': totalVehiclesCount,
      if (activeVehiclesWeight != null)
        'activeVehiclesWeight': activeVehiclesWeight,
      if (transportVehiclesWeight != null)
        'transportVehiclesWeight': transportVehiclesWeight,
      if (totalVehiclesWeight != null)
        'totalVehiclesWeight': totalVehiclesWeight,
      if (departureStation != null) 'departureStation': departureStation,
      if (currentStation != null) 'currentStation': currentStation,
      if (destinationStation != null) 'destinationStation': destinationStation,
      if (uzbLocation != null) 'uzbLocation': uzbLocation,
      if (uzbPerformedBy != null) 'uzbPerformedBy': uzbPerformedBy,
      if (jzbLocation != null) 'jzbLocation': jzbLocation,
      if (jzbPerformedBy != null) 'jzbPerformedBy': jzbPerformedBy,
      if (nbuStatus != null) 'nbuStatus': nbuStatus,
      if (doorControlStatus != null) 'doorControlStatus': doorControlStatus,
      if (powerSupplyStatus != null) 'powerSupplyStatus': powerSupplyStatus,
      if (highSpeedCarsStatus != null)
        'highSpeedCarsStatus': highSpeedCarsStatus,
      if (topSpeedAllowed != null) 'topSpeedAllowed': topSpeedAllowed,
      if (tjrFileName != null) 'tjrFileName': tjrFileName,
    });
  }

  TrainsCompanion copyWith({
    Value<int>? id,
    Value<String?>? trainName,
    Value<int?>? trainNumber,
    Value<int?>? maxSpeed,
    Value<int?>? trainLength,
    Value<int?>? trainCars,
    Value<String?>? trainWheels,
    Value<int?>? brakeTypeD,
    Value<int?>? brakeTypeK,
    Value<String?>? brakeMode,
    Value<int?>? brakingModeP,
    Value<int?>? brakingModeR,
    Value<int?>? brakingModeRMg,
    Value<int?>? brakePercent,
    Value<int?>? brakingPercentageActual,
    Value<int?>? brakingPercentageRequired,
    Value<int?>? brakingPercentageMissing,
    Value<int?>? activeVehiclesCount,
    Value<int?>? transportVehiclesCount,
    Value<int?>? totalVehiclesCount,
    Value<double?>? activeVehiclesWeight,
    Value<double?>? transportVehiclesWeight,
    Value<double?>? totalVehiclesWeight,
    Value<String?>? departureStation,
    Value<String?>? currentStation,
    Value<String?>? destinationStation,
    Value<String?>? uzbLocation,
    Value<String?>? uzbPerformedBy,
    Value<String?>? jzbLocation,
    Value<String?>? jzbPerformedBy,
    Value<String?>? nbuStatus,
    Value<String?>? doorControlStatus,
    Value<String?>? powerSupplyStatus,
    Value<String?>? highSpeedCarsStatus,
    Value<double?>? topSpeedAllowed,
    Value<String?>? tjrFileName,
  }) {
    return TrainsCompanion(
      id: id ?? this.id,
      trainName: trainName ?? this.trainName,
      trainNumber: trainNumber ?? this.trainNumber,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      trainLength: trainLength ?? this.trainLength,
      trainCars: trainCars ?? this.trainCars,
      trainWheels: trainWheels ?? this.trainWheels,
      brakeTypeD: brakeTypeD ?? this.brakeTypeD,
      brakeTypeK: brakeTypeK ?? this.brakeTypeK,
      brakeMode: brakeMode ?? this.brakeMode,
      brakingModeP: brakingModeP ?? this.brakingModeP,
      brakingModeR: brakingModeR ?? this.brakingModeR,
      brakingModeRMg: brakingModeRMg ?? this.brakingModeRMg,
      brakePercent: brakePercent ?? this.brakePercent,
      brakingPercentageActual:
          brakingPercentageActual ?? this.brakingPercentageActual,
      brakingPercentageRequired:
          brakingPercentageRequired ?? this.brakingPercentageRequired,
      brakingPercentageMissing:
          brakingPercentageMissing ?? this.brakingPercentageMissing,
      activeVehiclesCount: activeVehiclesCount ?? this.activeVehiclesCount,
      transportVehiclesCount:
          transportVehiclesCount ?? this.transportVehiclesCount,
      totalVehiclesCount: totalVehiclesCount ?? this.totalVehiclesCount,
      activeVehiclesWeight: activeVehiclesWeight ?? this.activeVehiclesWeight,
      transportVehiclesWeight:
          transportVehiclesWeight ?? this.transportVehiclesWeight,
      totalVehiclesWeight: totalVehiclesWeight ?? this.totalVehiclesWeight,
      departureStation: departureStation ?? this.departureStation,
      currentStation: currentStation ?? this.currentStation,
      destinationStation: destinationStation ?? this.destinationStation,
      uzbLocation: uzbLocation ?? this.uzbLocation,
      uzbPerformedBy: uzbPerformedBy ?? this.uzbPerformedBy,
      jzbLocation: jzbLocation ?? this.jzbLocation,
      jzbPerformedBy: jzbPerformedBy ?? this.jzbPerformedBy,
      nbuStatus: nbuStatus ?? this.nbuStatus,
      doorControlStatus: doorControlStatus ?? this.doorControlStatus,
      powerSupplyStatus: powerSupplyStatus ?? this.powerSupplyStatus,
      highSpeedCarsStatus: highSpeedCarsStatus ?? this.highSpeedCarsStatus,
      topSpeedAllowed: topSpeedAllowed ?? this.topSpeedAllowed,
      tjrFileName: tjrFileName ?? this.tjrFileName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trainName.present) {
      map['trainName'] = Variable<String>(trainName.value);
    }
    if (trainNumber.present) {
      map['trainNumber'] = Variable<int>(trainNumber.value);
    }
    if (maxSpeed.present) {
      map['maxSpeed'] = Variable<int>(maxSpeed.value);
    }
    if (trainLength.present) {
      map['trainLength'] = Variable<int>(trainLength.value);
    }
    if (trainCars.present) {
      map['trainCars'] = Variable<int>(trainCars.value);
    }
    if (trainWheels.present) {
      map['trainWheels'] = Variable<String>(trainWheels.value);
    }
    if (brakeTypeD.present) {
      map['brakeTypeD'] = Variable<int>(brakeTypeD.value);
    }
    if (brakeTypeK.present) {
      map['brakeTypeK'] = Variable<int>(brakeTypeK.value);
    }
    if (brakeMode.present) {
      map['brakeMode'] = Variable<String>(brakeMode.value);
    }
    if (brakingModeP.present) {
      map['brakingModeP'] = Variable<int>(brakingModeP.value);
    }
    if (brakingModeR.present) {
      map['brakingModeR'] = Variable<int>(brakingModeR.value);
    }
    if (brakingModeRMg.present) {
      map['brakingModeRMg'] = Variable<int>(brakingModeRMg.value);
    }
    if (brakePercent.present) {
      map['brakePercent'] = Variable<int>(brakePercent.value);
    }
    if (brakingPercentageActual.present) {
      map['brakingPercentageActual'] = Variable<int>(
        brakingPercentageActual.value,
      );
    }
    if (brakingPercentageRequired.present) {
      map['brakingPercentageRequired'] = Variable<int>(
        brakingPercentageRequired.value,
      );
    }
    if (brakingPercentageMissing.present) {
      map['brakingPercentageMissing'] = Variable<int>(
        brakingPercentageMissing.value,
      );
    }
    if (activeVehiclesCount.present) {
      map['activeVehiclesCount'] = Variable<int>(activeVehiclesCount.value);
    }
    if (transportVehiclesCount.present) {
      map['transportVehiclesCount'] = Variable<int>(
        transportVehiclesCount.value,
      );
    }
    if (totalVehiclesCount.present) {
      map['totalVehiclesCount'] = Variable<int>(totalVehiclesCount.value);
    }
    if (activeVehiclesWeight.present) {
      map['activeVehiclesWeight'] = Variable<double>(
        activeVehiclesWeight.value,
      );
    }
    if (transportVehiclesWeight.present) {
      map['transportVehiclesWeight'] = Variable<double>(
        transportVehiclesWeight.value,
      );
    }
    if (totalVehiclesWeight.present) {
      map['totalVehiclesWeight'] = Variable<double>(totalVehiclesWeight.value);
    }
    if (departureStation.present) {
      map['departureStation'] = Variable<String>(departureStation.value);
    }
    if (currentStation.present) {
      map['currentStation'] = Variable<String>(currentStation.value);
    }
    if (destinationStation.present) {
      map['destinationStation'] = Variable<String>(destinationStation.value);
    }
    if (uzbLocation.present) {
      map['uzbLocation'] = Variable<String>(uzbLocation.value);
    }
    if (uzbPerformedBy.present) {
      map['uzbPerformedBy'] = Variable<String>(uzbPerformedBy.value);
    }
    if (jzbLocation.present) {
      map['jzbLocation'] = Variable<String>(jzbLocation.value);
    }
    if (jzbPerformedBy.present) {
      map['jzbPerformedBy'] = Variable<String>(jzbPerformedBy.value);
    }
    if (nbuStatus.present) {
      map['nbuStatus'] = Variable<String>(nbuStatus.value);
    }
    if (doorControlStatus.present) {
      map['doorControlStatus'] = Variable<String>(doorControlStatus.value);
    }
    if (powerSupplyStatus.present) {
      map['powerSupplyStatus'] = Variable<String>(powerSupplyStatus.value);
    }
    if (highSpeedCarsStatus.present) {
      map['highSpeedCarsStatus'] = Variable<String>(highSpeedCarsStatus.value);
    }
    if (topSpeedAllowed.present) {
      map['topSpeedAllowed'] = Variable<double>(topSpeedAllowed.value);
    }
    if (tjrFileName.present) {
      map['tjrFileName'] = Variable<String>(tjrFileName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainsCompanion(')
          ..write('id: $id, ')
          ..write('trainName: $trainName, ')
          ..write('trainNumber: $trainNumber, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('trainLength: $trainLength, ')
          ..write('trainCars: $trainCars, ')
          ..write('trainWheels: $trainWheels, ')
          ..write('brakeTypeD: $brakeTypeD, ')
          ..write('brakeTypeK: $brakeTypeK, ')
          ..write('brakeMode: $brakeMode, ')
          ..write('brakingModeP: $brakingModeP, ')
          ..write('brakingModeR: $brakingModeR, ')
          ..write('brakingModeRMg: $brakingModeRMg, ')
          ..write('brakePercent: $brakePercent, ')
          ..write('brakingPercentageActual: $brakingPercentageActual, ')
          ..write('brakingPercentageRequired: $brakingPercentageRequired, ')
          ..write('brakingPercentageMissing: $brakingPercentageMissing, ')
          ..write('activeVehiclesCount: $activeVehiclesCount, ')
          ..write('transportVehiclesCount: $transportVehiclesCount, ')
          ..write('totalVehiclesCount: $totalVehiclesCount, ')
          ..write('activeVehiclesWeight: $activeVehiclesWeight, ')
          ..write('transportVehiclesWeight: $transportVehiclesWeight, ')
          ..write('totalVehiclesWeight: $totalVehiclesWeight, ')
          ..write('departureStation: $departureStation, ')
          ..write('currentStation: $currentStation, ')
          ..write('destinationStation: $destinationStation, ')
          ..write('uzbLocation: $uzbLocation, ')
          ..write('uzbPerformedBy: $uzbPerformedBy, ')
          ..write('jzbLocation: $jzbLocation, ')
          ..write('jzbPerformedBy: $jzbPerformedBy, ')
          ..write('nbuStatus: $nbuStatus, ')
          ..write('doorControlStatus: $doorControlStatus, ')
          ..write('powerSupplyStatus: $powerSupplyStatus, ')
          ..write('highSpeedCarsStatus: $highSpeedCarsStatus, ')
          ..write('topSpeedAllowed: $topSpeedAllowed, ')
          ..write('tjrFileName: $tjrFileName')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrainsTable trains = $TrainsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [trains];
}

typedef $$TrainsTableCreateCompanionBuilder =
    TrainsCompanion Function({
      Value<int> id,
      Value<String?> trainName,
      Value<int?> trainNumber,
      Value<int?> maxSpeed,
      Value<int?> trainLength,
      Value<int?> trainCars,
      Value<String?> trainWheels,
      Value<int?> brakeTypeD,
      Value<int?> brakeTypeK,
      Value<String?> brakeMode,
      Value<int?> brakingModeP,
      Value<int?> brakingModeR,
      Value<int?> brakingModeRMg,
      Value<int?> brakePercent,
      Value<int?> brakingPercentageActual,
      Value<int?> brakingPercentageRequired,
      Value<int?> brakingPercentageMissing,
      Value<int?> activeVehiclesCount,
      Value<int?> transportVehiclesCount,
      Value<int?> totalVehiclesCount,
      Value<double?> activeVehiclesWeight,
      Value<double?> transportVehiclesWeight,
      Value<double?> totalVehiclesWeight,
      Value<String?> departureStation,
      Value<String?> currentStation,
      Value<String?> destinationStation,
      Value<String?> uzbLocation,
      Value<String?> uzbPerformedBy,
      Value<String?> jzbLocation,
      Value<String?> jzbPerformedBy,
      Value<String?> nbuStatus,
      Value<String?> doorControlStatus,
      Value<String?> powerSupplyStatus,
      Value<String?> highSpeedCarsStatus,
      Value<double?> topSpeedAllowed,
      Value<String?> tjrFileName,
    });
typedef $$TrainsTableUpdateCompanionBuilder =
    TrainsCompanion Function({
      Value<int> id,
      Value<String?> trainName,
      Value<int?> trainNumber,
      Value<int?> maxSpeed,
      Value<int?> trainLength,
      Value<int?> trainCars,
      Value<String?> trainWheels,
      Value<int?> brakeTypeD,
      Value<int?> brakeTypeK,
      Value<String?> brakeMode,
      Value<int?> brakingModeP,
      Value<int?> brakingModeR,
      Value<int?> brakingModeRMg,
      Value<int?> brakePercent,
      Value<int?> brakingPercentageActual,
      Value<int?> brakingPercentageRequired,
      Value<int?> brakingPercentageMissing,
      Value<int?> activeVehiclesCount,
      Value<int?> transportVehiclesCount,
      Value<int?> totalVehiclesCount,
      Value<double?> activeVehiclesWeight,
      Value<double?> transportVehiclesWeight,
      Value<double?> totalVehiclesWeight,
      Value<String?> departureStation,
      Value<String?> currentStation,
      Value<String?> destinationStation,
      Value<String?> uzbLocation,
      Value<String?> uzbPerformedBy,
      Value<String?> jzbLocation,
      Value<String?> jzbPerformedBy,
      Value<String?> nbuStatus,
      Value<String?> doorControlStatus,
      Value<String?> powerSupplyStatus,
      Value<String?> highSpeedCarsStatus,
      Value<double?> topSpeedAllowed,
      Value<String?> tjrFileName,
    });

class $$TrainsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainsTable> {
  $$TrainsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainName => $composableBuilder(
    column: $table.trainName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trainNumber => $composableBuilder(
    column: $table.trainNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trainLength => $composableBuilder(
    column: $table.trainLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trainCars => $composableBuilder(
    column: $table.trainCars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainWheels => $composableBuilder(
    column: $table.trainWheels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakeTypeD => $composableBuilder(
    column: $table.brakeTypeD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakeTypeK => $composableBuilder(
    column: $table.brakeTypeK,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brakeMode => $composableBuilder(
    column: $table.brakeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakingModeP => $composableBuilder(
    column: $table.brakingModeP,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakingModeR => $composableBuilder(
    column: $table.brakingModeR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakingModeRMg => $composableBuilder(
    column: $table.brakingModeRMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakePercent => $composableBuilder(
    column: $table.brakePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakingPercentageActual => $composableBuilder(
    column: $table.brakingPercentageActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakingPercentageRequired => $composableBuilder(
    column: $table.brakingPercentageRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakingPercentageMissing => $composableBuilder(
    column: $table.brakingPercentageMissing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeVehiclesCount => $composableBuilder(
    column: $table.activeVehiclesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transportVehiclesCount => $composableBuilder(
    column: $table.transportVehiclesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalVehiclesCount => $composableBuilder(
    column: $table.totalVehiclesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get activeVehiclesWeight => $composableBuilder(
    column: $table.activeVehiclesWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get transportVehiclesWeight => $composableBuilder(
    column: $table.transportVehiclesWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalVehiclesWeight => $composableBuilder(
    column: $table.totalVehiclesWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departureStation => $composableBuilder(
    column: $table.departureStation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentStation => $composableBuilder(
    column: $table.currentStation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationStation => $composableBuilder(
    column: $table.destinationStation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uzbLocation => $composableBuilder(
    column: $table.uzbLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uzbPerformedBy => $composableBuilder(
    column: $table.uzbPerformedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jzbLocation => $composableBuilder(
    column: $table.jzbLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jzbPerformedBy => $composableBuilder(
    column: $table.jzbPerformedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nbuStatus => $composableBuilder(
    column: $table.nbuStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doorControlStatus => $composableBuilder(
    column: $table.doorControlStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get powerSupplyStatus => $composableBuilder(
    column: $table.powerSupplyStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get highSpeedCarsStatus => $composableBuilder(
    column: $table.highSpeedCarsStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topSpeedAllowed => $composableBuilder(
    column: $table.topSpeedAllowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tjrFileName => $composableBuilder(
    column: $table.tjrFileName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrainsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainsTable> {
  $$TrainsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainName => $composableBuilder(
    column: $table.trainName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trainNumber => $composableBuilder(
    column: $table.trainNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trainLength => $composableBuilder(
    column: $table.trainLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trainCars => $composableBuilder(
    column: $table.trainCars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainWheels => $composableBuilder(
    column: $table.trainWheels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakeTypeD => $composableBuilder(
    column: $table.brakeTypeD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakeTypeK => $composableBuilder(
    column: $table.brakeTypeK,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brakeMode => $composableBuilder(
    column: $table.brakeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakingModeP => $composableBuilder(
    column: $table.brakingModeP,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakingModeR => $composableBuilder(
    column: $table.brakingModeR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakingModeRMg => $composableBuilder(
    column: $table.brakingModeRMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakePercent => $composableBuilder(
    column: $table.brakePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakingPercentageActual => $composableBuilder(
    column: $table.brakingPercentageActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakingPercentageRequired => $composableBuilder(
    column: $table.brakingPercentageRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakingPercentageMissing => $composableBuilder(
    column: $table.brakingPercentageMissing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeVehiclesCount => $composableBuilder(
    column: $table.activeVehiclesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transportVehiclesCount => $composableBuilder(
    column: $table.transportVehiclesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalVehiclesCount => $composableBuilder(
    column: $table.totalVehiclesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get activeVehiclesWeight => $composableBuilder(
    column: $table.activeVehiclesWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get transportVehiclesWeight => $composableBuilder(
    column: $table.transportVehiclesWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalVehiclesWeight => $composableBuilder(
    column: $table.totalVehiclesWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departureStation => $composableBuilder(
    column: $table.departureStation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentStation => $composableBuilder(
    column: $table.currentStation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationStation => $composableBuilder(
    column: $table.destinationStation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uzbLocation => $composableBuilder(
    column: $table.uzbLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uzbPerformedBy => $composableBuilder(
    column: $table.uzbPerformedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jzbLocation => $composableBuilder(
    column: $table.jzbLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jzbPerformedBy => $composableBuilder(
    column: $table.jzbPerformedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nbuStatus => $composableBuilder(
    column: $table.nbuStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doorControlStatus => $composableBuilder(
    column: $table.doorControlStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get powerSupplyStatus => $composableBuilder(
    column: $table.powerSupplyStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get highSpeedCarsStatus => $composableBuilder(
    column: $table.highSpeedCarsStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topSpeedAllowed => $composableBuilder(
    column: $table.topSpeedAllowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tjrFileName => $composableBuilder(
    column: $table.tjrFileName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrainsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainsTable> {
  $$TrainsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trainName =>
      $composableBuilder(column: $table.trainName, builder: (column) => column);

  GeneratedColumn<int> get trainNumber => $composableBuilder(
    column: $table.trainNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxSpeed =>
      $composableBuilder(column: $table.maxSpeed, builder: (column) => column);

  GeneratedColumn<int> get trainLength => $composableBuilder(
    column: $table.trainLength,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trainCars =>
      $composableBuilder(column: $table.trainCars, builder: (column) => column);

  GeneratedColumn<String> get trainWheels => $composableBuilder(
    column: $table.trainWheels,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakeTypeD => $composableBuilder(
    column: $table.brakeTypeD,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakeTypeK => $composableBuilder(
    column: $table.brakeTypeK,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brakeMode =>
      $composableBuilder(column: $table.brakeMode, builder: (column) => column);

  GeneratedColumn<int> get brakingModeP => $composableBuilder(
    column: $table.brakingModeP,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakingModeR => $composableBuilder(
    column: $table.brakingModeR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakingModeRMg => $composableBuilder(
    column: $table.brakingModeRMg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakePercent => $composableBuilder(
    column: $table.brakePercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakingPercentageActual => $composableBuilder(
    column: $table.brakingPercentageActual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakingPercentageRequired => $composableBuilder(
    column: $table.brakingPercentageRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakingPercentageMissing => $composableBuilder(
    column: $table.brakingPercentageMissing,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activeVehiclesCount => $composableBuilder(
    column: $table.activeVehiclesCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get transportVehiclesCount => $composableBuilder(
    column: $table.transportVehiclesCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalVehiclesCount => $composableBuilder(
    column: $table.totalVehiclesCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get activeVehiclesWeight => $composableBuilder(
    column: $table.activeVehiclesWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get transportVehiclesWeight => $composableBuilder(
    column: $table.transportVehiclesWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalVehiclesWeight => $composableBuilder(
    column: $table.totalVehiclesWeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departureStation => $composableBuilder(
    column: $table.departureStation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentStation => $composableBuilder(
    column: $table.currentStation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationStation => $composableBuilder(
    column: $table.destinationStation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uzbLocation => $composableBuilder(
    column: $table.uzbLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uzbPerformedBy => $composableBuilder(
    column: $table.uzbPerformedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jzbLocation => $composableBuilder(
    column: $table.jzbLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jzbPerformedBy => $composableBuilder(
    column: $table.jzbPerformedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nbuStatus =>
      $composableBuilder(column: $table.nbuStatus, builder: (column) => column);

  GeneratedColumn<String> get doorControlStatus => $composableBuilder(
    column: $table.doorControlStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get powerSupplyStatus => $composableBuilder(
    column: $table.powerSupplyStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get highSpeedCarsStatus => $composableBuilder(
    column: $table.highSpeedCarsStatus,
    builder: (column) => column,
  );

  GeneratedColumn<double> get topSpeedAllowed => $composableBuilder(
    column: $table.topSpeedAllowed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tjrFileName => $composableBuilder(
    column: $table.tjrFileName,
    builder: (column) => column,
  );
}

class $$TrainsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainsTable,
          Train,
          $$TrainsTableFilterComposer,
          $$TrainsTableOrderingComposer,
          $$TrainsTableAnnotationComposer,
          $$TrainsTableCreateCompanionBuilder,
          $$TrainsTableUpdateCompanionBuilder,
          (Train, BaseReferences<_$AppDatabase, $TrainsTable, Train>),
          Train,
          PrefetchHooks Function()
        > {
  $$TrainsTableTableManager(_$AppDatabase db, $TrainsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> trainName = const Value.absent(),
                Value<int?> trainNumber = const Value.absent(),
                Value<int?> maxSpeed = const Value.absent(),
                Value<int?> trainLength = const Value.absent(),
                Value<int?> trainCars = const Value.absent(),
                Value<String?> trainWheels = const Value.absent(),
                Value<int?> brakeTypeD = const Value.absent(),
                Value<int?> brakeTypeK = const Value.absent(),
                Value<String?> brakeMode = const Value.absent(),
                Value<int?> brakingModeP = const Value.absent(),
                Value<int?> brakingModeR = const Value.absent(),
                Value<int?> brakingModeRMg = const Value.absent(),
                Value<int?> brakePercent = const Value.absent(),
                Value<int?> brakingPercentageActual = const Value.absent(),
                Value<int?> brakingPercentageRequired = const Value.absent(),
                Value<int?> brakingPercentageMissing = const Value.absent(),
                Value<int?> activeVehiclesCount = const Value.absent(),
                Value<int?> transportVehiclesCount = const Value.absent(),
                Value<int?> totalVehiclesCount = const Value.absent(),
                Value<double?> activeVehiclesWeight = const Value.absent(),
                Value<double?> transportVehiclesWeight = const Value.absent(),
                Value<double?> totalVehiclesWeight = const Value.absent(),
                Value<String?> departureStation = const Value.absent(),
                Value<String?> currentStation = const Value.absent(),
                Value<String?> destinationStation = const Value.absent(),
                Value<String?> uzbLocation = const Value.absent(),
                Value<String?> uzbPerformedBy = const Value.absent(),
                Value<String?> jzbLocation = const Value.absent(),
                Value<String?> jzbPerformedBy = const Value.absent(),
                Value<String?> nbuStatus = const Value.absent(),
                Value<String?> doorControlStatus = const Value.absent(),
                Value<String?> powerSupplyStatus = const Value.absent(),
                Value<String?> highSpeedCarsStatus = const Value.absent(),
                Value<double?> topSpeedAllowed = const Value.absent(),
                Value<String?> tjrFileName = const Value.absent(),
              }) => TrainsCompanion(
                id: id,
                trainName: trainName,
                trainNumber: trainNumber,
                maxSpeed: maxSpeed,
                trainLength: trainLength,
                trainCars: trainCars,
                trainWheels: trainWheels,
                brakeTypeD: brakeTypeD,
                brakeTypeK: brakeTypeK,
                brakeMode: brakeMode,
                brakingModeP: brakingModeP,
                brakingModeR: brakingModeR,
                brakingModeRMg: brakingModeRMg,
                brakePercent: brakePercent,
                brakingPercentageActual: brakingPercentageActual,
                brakingPercentageRequired: brakingPercentageRequired,
                brakingPercentageMissing: brakingPercentageMissing,
                activeVehiclesCount: activeVehiclesCount,
                transportVehiclesCount: transportVehiclesCount,
                totalVehiclesCount: totalVehiclesCount,
                activeVehiclesWeight: activeVehiclesWeight,
                transportVehiclesWeight: transportVehiclesWeight,
                totalVehiclesWeight: totalVehiclesWeight,
                departureStation: departureStation,
                currentStation: currentStation,
                destinationStation: destinationStation,
                uzbLocation: uzbLocation,
                uzbPerformedBy: uzbPerformedBy,
                jzbLocation: jzbLocation,
                jzbPerformedBy: jzbPerformedBy,
                nbuStatus: nbuStatus,
                doorControlStatus: doorControlStatus,
                powerSupplyStatus: powerSupplyStatus,
                highSpeedCarsStatus: highSpeedCarsStatus,
                topSpeedAllowed: topSpeedAllowed,
                tjrFileName: tjrFileName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> trainName = const Value.absent(),
                Value<int?> trainNumber = const Value.absent(),
                Value<int?> maxSpeed = const Value.absent(),
                Value<int?> trainLength = const Value.absent(),
                Value<int?> trainCars = const Value.absent(),
                Value<String?> trainWheels = const Value.absent(),
                Value<int?> brakeTypeD = const Value.absent(),
                Value<int?> brakeTypeK = const Value.absent(),
                Value<String?> brakeMode = const Value.absent(),
                Value<int?> brakingModeP = const Value.absent(),
                Value<int?> brakingModeR = const Value.absent(),
                Value<int?> brakingModeRMg = const Value.absent(),
                Value<int?> brakePercent = const Value.absent(),
                Value<int?> brakingPercentageActual = const Value.absent(),
                Value<int?> brakingPercentageRequired = const Value.absent(),
                Value<int?> brakingPercentageMissing = const Value.absent(),
                Value<int?> activeVehiclesCount = const Value.absent(),
                Value<int?> transportVehiclesCount = const Value.absent(),
                Value<int?> totalVehiclesCount = const Value.absent(),
                Value<double?> activeVehiclesWeight = const Value.absent(),
                Value<double?> transportVehiclesWeight = const Value.absent(),
                Value<double?> totalVehiclesWeight = const Value.absent(),
                Value<String?> departureStation = const Value.absent(),
                Value<String?> currentStation = const Value.absent(),
                Value<String?> destinationStation = const Value.absent(),
                Value<String?> uzbLocation = const Value.absent(),
                Value<String?> uzbPerformedBy = const Value.absent(),
                Value<String?> jzbLocation = const Value.absent(),
                Value<String?> jzbPerformedBy = const Value.absent(),
                Value<String?> nbuStatus = const Value.absent(),
                Value<String?> doorControlStatus = const Value.absent(),
                Value<String?> powerSupplyStatus = const Value.absent(),
                Value<String?> highSpeedCarsStatus = const Value.absent(),
                Value<double?> topSpeedAllowed = const Value.absent(),
                Value<String?> tjrFileName = const Value.absent(),
              }) => TrainsCompanion.insert(
                id: id,
                trainName: trainName,
                trainNumber: trainNumber,
                maxSpeed: maxSpeed,
                trainLength: trainLength,
                trainCars: trainCars,
                trainWheels: trainWheels,
                brakeTypeD: brakeTypeD,
                brakeTypeK: brakeTypeK,
                brakeMode: brakeMode,
                brakingModeP: brakingModeP,
                brakingModeR: brakingModeR,
                brakingModeRMg: brakingModeRMg,
                brakePercent: brakePercent,
                brakingPercentageActual: brakingPercentageActual,
                brakingPercentageRequired: brakingPercentageRequired,
                brakingPercentageMissing: brakingPercentageMissing,
                activeVehiclesCount: activeVehiclesCount,
                transportVehiclesCount: transportVehiclesCount,
                totalVehiclesCount: totalVehiclesCount,
                activeVehiclesWeight: activeVehiclesWeight,
                transportVehiclesWeight: transportVehiclesWeight,
                totalVehiclesWeight: totalVehiclesWeight,
                departureStation: departureStation,
                currentStation: currentStation,
                destinationStation: destinationStation,
                uzbLocation: uzbLocation,
                uzbPerformedBy: uzbPerformedBy,
                jzbLocation: jzbLocation,
                jzbPerformedBy: jzbPerformedBy,
                nbuStatus: nbuStatus,
                doorControlStatus: doorControlStatus,
                powerSupplyStatus: powerSupplyStatus,
                highSpeedCarsStatus: highSpeedCarsStatus,
                topSpeedAllowed: topSpeedAllowed,
                tjrFileName: tjrFileName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrainsTable, Train>(table),
                  BaseReferences<_$AppDatabase, $TrainsTable, Train>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrainsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainsTable,
      Train,
      $$TrainsTableFilterComposer,
      $$TrainsTableOrderingComposer,
      $$TrainsTableAnnotationComposer,
      $$TrainsTableCreateCompanionBuilder,
      $$TrainsTableUpdateCompanionBuilder,
      (Train, BaseReferences<_$AppDatabase, $TrainsTable, Train>),
      Train,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrainsTableTableManager get trains =>
      $$TrainsTableTableManager(_db, _db.trains);
}
