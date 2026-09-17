import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() =>
      _DriverDashboardScreenState();
}

class _DriverDashboardScreenState
    extends State<DriverDashboardScreen> {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _licenseController =
      TextEditingController();

  final TextEditingController _kmController =
      TextEditingController();

  bool _isLoading = true;
  bool _hasD1 = false;
  bool _hasCreatorPerk = false;

  bool _isTraining = false;

  String? _selectedVehicle;
  String _selectedUnit = 'km';

  List<String> _myVehicles = [];

  String _savedName = '';
  String _savedLicense = '';

  // ============================================================
  // DOSTUPNÉ STROJE
  // ============================================================

  final Map<String, String> _availableVehicles = {
    'VECTRON': '193 / 383 (Vectron)',
    '854': '854 (Hydra na steroidech)',
    '640': '640 (Panter)',
    '471': 'CityElefant',
    '749': 'T478.1 (749 - Barča, Zamračená)',
    '52T': '52T (Tramvaj)',
    'KT8': 'KT8 (Tramvaj)',
    'METRO': 'Souprava metra',
  };

  // ============================================================
  // VÝBĚR STROJŮ
  // ============================================================

  List<String> get _vehicleOptions {
    // Zácvik = všechny stroje
    if (_isTraining) {
      return _availableVehicles.keys.toList();
    }

    // Běžná jízda = pouze vlastní oprávnění
    return _myVehicles;
  }

  // ============================================================
  // INIT / DISPOSE
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  // ============================================================
  // NAČTENÍ OPRÁVNĚNÍ
  // ============================================================

  Future<void> _loadPermissions() async {
    final prefs =
        await SharedPreferences.getInstance();

    final unlocked =
        prefs.getStringList('unlockedVehicles') ?? [];

    _savedName =
        prefs.getString('driverName') ?? '';

    _savedLicense =
        prefs.getString('licenseNumber') ?? '';

    final myVehicles = unlocked
        .where(
          (v) =>
              v != 'D1_ZPUSOBILOST' &&
              v != 'PERK_CREATOR',
        )
        .where(
          (v) => _availableVehicles.containsKey(v),
        )
        .toList();

    if (!mounted) return;

    setState(() {
      _nameController.text = _savedName;
      _licenseController.text = _savedLicense;

      _hasD1 =
          unlocked.contains('D1_ZPUSOBILOST');

      _hasCreatorPerk =
          unlocked.contains('PERK_CREATOR');

      _myVehicles = myVehicles;

      if (_myVehicles.isNotEmpty) {
        _selectedVehicle =
            _myVehicles.first;
      }

      _isLoading = false;
    });
  }

  // ============================================================
  // PŘIDÁNÍ KILOMETRŮ
  // ============================================================

  Future<void> _addKilometers() async {
    final String typedName =
        _nameController.text.trim();

    final String typedLicense =
        _licenseController.text.trim();

    final double? inputVal =
        double.tryParse(
      _kmController.text
          .trim()
          .replaceAll(',', '.'),
    );

    if (typedName.isEmpty ||
        typedLicense.isEmpty ||
        inputVal == null ||
        inputVal <= 0 ||
        _selectedVehicle == null) {
      _showMessage(
        'Vyplňte všechny údaje správně.',
        color: Colors.red,
      );
      return;
    }

    // ==========================================================
    // KONTROLA ZÁPISU CIZÍHO VÝKONU
    // ==========================================================

    if (!_hasCreatorPerk) {
      if (typedName != _savedName ||
          typedLicense != _savedLicense) {
        _showMessage(
          'Nemáte oprávnění zapisovat výkon za jiné osoby.',
          color: Colors.red,
        );
        return;
      }
    }

    // ==========================================================
    // KONTROLA STROJE
    // ==========================================================

    // Běžná jízda musí mít vlastní oprávnění.
    if (!_isTraining &&
        !_myVehicles.contains(_selectedVehicle)) {
      _showMessage(
        'Tento stroj nemáte ve svých oprávněních.',
        color: Colors.red,
      );
      return;
    }

    // Zácvik může použít libovolný stroj.

    // ==========================================================
    // PŘEVOD JEDNOTEK
    // ==========================================================

    final double kmToAdd =
        _selectedUnit == 'm'
            ? inputVal / 1000.0
            : inputVal;

    // ==========================================================
    // KLÍČ DATABÁZE
    // ==========================================================

    final driverKey =
        typedLicense.replaceAll(
      RegExp(r'[^a-zA-Z0-9]'),
      '_',
    );

    try {
      final String vehicleName =
          _availableVehicles[
                  _selectedVehicle!] ??
              _selectedVehicle!;

      final Map<String, dynamic>
          dataToUpdate = {
        'name': typedName,
        'license': typedLicense,
        'last_updated':
            FieldValue.serverTimestamp(),
        'last_vehicle': vehicleName,
        'total_km':
            FieldValue.increment(
          kmToAdd,
        ),
      };

      // Zácvik se zapisuje i samostatně.
      if (_isTraining) {
        dataToUpdate['training_km'] =
            FieldValue.increment(
          kmToAdd,
        );
      }

      await _db
          .collection('drivers')
          .doc(driverKey)
          .set(
            dataToUpdate,
            SetOptions(
              merge: true,
            ),
          );

      final double writtenKm = kmToAdd;

      setState(() {
        _isTraining = false;
        _kmController.clear();

        // Po vypnutí zácviku se vrátíme
        // na první vlastní stroj.
        if (_myVehicles.isNotEmpty &&
            !_myVehicles.contains(
                _selectedVehicle)) {
          _selectedVehicle =
              _myVehicles.first;
        }
      });

      if (!mounted) return;

      _showMessage(
        'Zapsáno ${_formatNumber(inputVal)} '
        '$_selectedUnit na stroji $vehicleName '
        '(${_formatNumber(writtenKm)} km).',
        color: Colors.green.shade700,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Chyba při zápisu: $e',
        color: Colors.red,
      );
    }
  }

  // ============================================================
  // POMOCNÉ FUNKCE
  // ============================================================

  String _formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number
          .toInt()
          .toString();
    }

    return number
        .toStringAsFixed(3)
        .replaceFirst(
          RegExp(r'0+$'),
          '',
        )
        .replaceFirst(
          RegExp(r'\.$'),
          '',
        );
  }

  void _showMessage(
    String message, {
    Color? color,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior:
            SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ============================================================
  // PŘEPNUTÍ ZÁCVIKU
  // ============================================================

  void _setTraining(bool value) {
    setState(() {
      _isTraining = value;

      if (_isTraining) {
        // Pokud aktuální stroj existuje
        // mezi všemi stroji, necháme ho.
        //
        // Jinak vezmeme první dostupný.
        if (!_vehicleOptions.contains(
            _selectedVehicle)) {
          _selectedVehicle =
              _vehicleOptions.isNotEmpty
                  ? _vehicleOptions.first
                  : null;
        }
      } else {
        // Po vypnutí zácviku musí být
        // vybraný stroj z vlastních oprávnění.
        if (!_myVehicles.contains(
            _selectedVehicle)) {
          _selectedVehicle =
              _myVehicles.isNotEmpty
                  ? _myVehicles.first
                  : null;
        }
      }
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            Theme.of(context)
                .scaffoldBackgroundColor,
        body: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final theme =
        Theme.of(context);

    final colors =
        theme.colorScheme;

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor:
          colors.surface,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        title: const Text(
          'Žebříček a zápis km',
          style: TextStyle(
            fontWeight:
                FontWeight.w700,
          ),
        ),

        backgroundColor:
            isDark
                ? const Color(0xFF8D4F00)
                : Colors.orangeAccent,

        foregroundColor:
            Colors.white,

        elevation: 0,
      ),

      body: Column(
        children: [
          // ======================================================
          // HORNÍ ČÁST
          // ======================================================

          if (!_hasD1)
            _buildLockedCard(context)
          else
            _buildEntryCard(
              context,
              colors,
            ),

          Divider(
            height: 1,
            thickness: 1,
            color:
                colors.outlineVariant,
          ),

          // ======================================================
          // ŽEBŘÍČEK
          // ======================================================

          Expanded(
            child: _buildLeaderboard(
              context,
              colors,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ZABLOKOVANÝ ZÁPIS
  // ============================================================

  Widget _buildLockedCard(
      BuildContext context) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),

      color: Colors.red
          .withOpacity(0.08),

      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: Colors.red
                  .withOpacity(0.12),
              shape:
                  BoxShape.circle,
            ),

            child: const Icon(
              Icons.lock_outline,
              color: Colors.red,
              size: 30,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Zápis výkonu je zablokován',
            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontWeight:
                  FontWeight.w800,
              color: Colors.red,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Pro zápis kilometrů musíte '
            'nejprve složit zkoušku a '
            'zadat kód pro Odbornou '
            'způsobilost SŽ D1.',
            textAlign:
                TextAlign.center,

            style: TextStyle(
              color: colors
                  .onSurface,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KARTA ZÁPISU
  // ============================================================

  Widget _buildEntryCard(
    BuildContext context,
    ColorScheme colors,
  ) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,

      color: colors.surface,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 800,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // NADPIS
                // ==================================================

                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,

                      decoration:
                          BoxDecoration(
                        color: Colors
                            .orange
                            .withOpacity(
                          0.12,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          13,
                        ),
                      ),

                      child:
                          const Icon(
                        Icons
                            .add_road,
                        color:
                            Colors
                                .orange,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Zápis výkonu',
                            style:
                                TextStyle(
                              fontSize:
                                  19,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Přidejte ujetou vzdálenost do systému.',
                            style:
                                TextStyle(
                              color:
                                  Colors.grey,
                              fontSize:
                                  12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_hasCreatorPerk)
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.amber
                                  .withOpacity(
                            0.13,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),

                        child: const Row(
                          mainAxisSize:
                              MainAxisSize
                                  .min,
                          children: [
                            Icon(
                              Icons
                                  .admin_panel_settings,
                              color:
                                  Colors.amber,
                              size: 18,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'ADMIN',
                              style:
                                  TextStyle(
                                color:
                                    Colors.amber,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                fontSize:
                                    10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(
                  height: 16,
                ),

                // ==================================================
                // JMÉNO + LICENCE
                // ==================================================

                LayoutBuilder(
                  builder:
                      (context, constraints) {
                    final bool compact =
                        constraints
                                .maxWidth <
                            540;

                    if (compact) {
                      return Column(
                        children: [
                          _buildTextField(
                            controller:
                                _nameController,
                            label:
                                'Jméno',
                            icon: Icons
                                .person_outline,
                            readOnly:
                                !_hasCreatorPerk,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          _buildTextField(
                            controller:
                                _licenseController,
                            label:
                                'Licence',
                            icon: Icons
                                .badge_outlined,
                            readOnly:
                                !_hasCreatorPerk,
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child:
                              _buildTextField(
                            controller:
                                _nameController,
                            label:
                                'Jméno',
                            icon: Icons
                                .person_outline,
                            readOnly:
                                !_hasCreatorPerk,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child:
                              _buildTextField(
                            controller:
                                _licenseController,
                            label:
                                'Licence',
                            icon: Icons
                                .badge_outlined,
                            readOnly:
                                !_hasCreatorPerk,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                // ==================================================
                // VZDÁLENOST + JEDNOTKA
                // ==================================================

                LayoutBuilder(
                  builder:
                      (context, constraints) {
                    final bool compact =
                        constraints
                                .maxWidth <
                            460;

                    if (compact) {
                      return Column(
                        children: [
                          _buildDistanceField(),

                          const SizedBox(
                            height: 10,
                          ),

                          _buildUnitDropdown(),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child:
                              _buildDistanceField(),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child:
                              _buildUnitDropdown(),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                // ==================================================
                // STROJ
                // ==================================================

                _buildVehicleDropdown(),

                const SizedBox(
                  height: 4,
                ),

                // ==================================================
                // ZÁCVIK
                // ==================================================

                Container(
                  decoration:
                      BoxDecoration(
                    color: _isTraining
                        ? Colors.blue
                            .withOpacity(
                            isDark
                                ? 0.14
                                : 0.07,
                          )
                        : Colors
                            .transparent,

                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),
                  ),

                  child:
                      CheckboxListTile(
                    title: const Text(
                      'Zácviková jízda',
                      style: TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),

                    subtitle:
                        Text(
                      _isTraining
                          ? 'Aktivní – lze zvolit libovolný stroj.'
                          : 'Běžná jízda – pouze vlastní oprávnění.',
                    ),

                    value:
                        _isTraining,

                    onChanged:
                        (value) {
                      _setTraining(
                        value ??
                            false,
                      );
                    },

                    secondary:
                        Icon(
                      _isTraining
                          ? Icons
                              .school
                          : Icons
                              .school_outlined,

                      color:
                          _isTraining
                              ? Colors.blue
                              : colors
                                  .onSurfaceVariant,
                    ),

                    controlAffinity:
                        ListTileControlAffinity
                            .leading,

                    contentPadding:
                        EdgeInsets.zero,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                // ==================================================
                // TLAČÍTKO
                // ==================================================

                SizedBox(
                  width:
                      double.infinity,

                  child:
                      FilledButton.icon(
                    icon: const Icon(
                      Icons.save_outlined,
                    ),

                    label:
                        const Text(
                      'Zapsat hodnoty do systému',
                    ),

                    onPressed:
                        // DŮLEŽITÁ OPRAVA:
                        // při zácviku lze zapisovat
                        // i bez vlastních oprávnění.
                        _isTraining ||
                                _myVehicles
                                    .isNotEmpty
                            ? _addKilometers
                            : null,

                    style:
                        FilledButton.styleFrom(
                      backgroundColor:
                          Colors
                              .orange
                              .shade700,

                      foregroundColor:
                          Colors.white,

                      minimumSize:
                          const Size
                              .fromHeight(
                        50,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController
        controller,

    required String label,

    required IconData icon,

    bool readOnly = false,
  }) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return TextField(
      controller:
          controller,

      readOnly:
          readOnly,

      decoration:
          InputDecoration(
        labelText:
            label,

        prefixIcon:
            Icon(icon),

        filled: true,

        fillColor: readOnly
            ? colors
                .surfaceContainerHighest
                .withOpacity(0.65)
            : colors
                .surfaceContainerHighest,

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  // ============================================================
  // DISTANCE FIELD
  // ============================================================

  Widget _buildDistanceField() {
    return TextField(
      controller:
          _kmController,

      keyboardType:
          const TextInputType
              .numberWithOptions(
        decimal: true,
      ),

      decoration:
          const InputDecoration(
        labelText:
            'Ujetá vzdálenost',

        prefixIcon:
            Icon(Icons.add_road),

        border:
            OutlineInputBorder(),

        filled: true,
      ),
    );
  }

  // ============================================================
  // UNIT DROPDOWN
  // ============================================================

  Widget _buildUnitDropdown() {
    return DropdownButtonFormField<String>(
      decoration:
          const InputDecoration(
        labelText:
            'Jednotka',

        prefixIcon:
            Icon(Icons.straighten),

        border:
            OutlineInputBorder(),

        filled: true,
      ),

      value:
          _selectedUnit,

      items: const [
        DropdownMenuItem(
          value: 'km',
          child:
              Text('Kilometry'),
        ),
        DropdownMenuItem(
          value: 'm',
          child:
              Text('Metry'),
        ),
      ],

      onChanged:
          (value) {
        if (value == null) return;

        setState(() {
          _selectedUnit =
              value;
        });
      },
    );
  }

  // ============================================================
  // VEHICLE DROPDOWN
  // ============================================================

  Widget _buildVehicleDropdown() {
    final bool hasVehicles =
        _vehicleOptions.isNotEmpty;

    return DropdownButtonFormField<String>(
      decoration:
          InputDecoration(
        labelText:
            _isTraining
                ? 'Simulátor / stroj – zácvik'
                : 'Simulátor / stroj',

        helperText:
            _isTraining
                ? 'Při zácviku jsou dostupné všechny stroje.'
                : hasVehicles
                    ? 'Zobrazují se pouze vaše oprávnění.'
                    : 'Nemáte zatím žádné oprávnění.',

        prefixIcon:
            Icon(
          _isTraining
              ? Icons.school_outlined
              : Icons.train_outlined,
        ),

        border:
            const OutlineInputBorder(),

        filled: true,
      ),

      value:
          _vehicleOptions.contains(
        _selectedVehicle,
      )
              ? _selectedVehicle
              : null,

      items: _vehicleOptions
          .map(
            (v) {
              return DropdownMenuItem<String>(
                value: v,

                child: Text(
                  _availableVehicles[v] ??
                      v,

                  overflow:
                      TextOverflow.ellipsis,
                ),
              );
            },
          )
          .toList(),

      onChanged:
          hasVehicles
              ? (value) {
                  setState(() {
                    _selectedVehicle =
                        value;
                  });
                }
              : null,

      hint:
          const Text(
        'Vyberte stroj',
      ),
    );
  }

  // ============================================================
  // ŽEBŘÍČEK
  // ============================================================

  Widget _buildLeaderboard(
    BuildContext context,
    ColorScheme colors,
  ) {
    return StreamBuilder<
        QuerySnapshot>(
      stream: _db
          .collection('drivers')
          .orderBy(
            'total_km',
            descending: true,
          )
          .snapshots(),

      builder:
          (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Text(
                'Chyba při načítání žebříčku:\n'
                '${snapshot.error}',
                textAlign:
                    TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return _buildEmptyLeaderboard();
        }

        final drivers =
            snapshot.data!.docs;

        final firstDriverData =
            drivers.first.data()
                as Map<String, dynamic>;

        final double maxKm =
            _toDouble(
          firstDriverData[
                  'total_km'] ??
              0,
        );

        final double scaleMax =
            maxKm <= 0 ? 1 : maxKm;

        return ListView.builder(
          physics:
              const BouncingScrollPhysics(),

          padding:
              const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            30,
          ),

          itemCount:
              drivers.length,

          itemBuilder:
              (context, index) {
            final d =
                drivers[index].data()
                    as Map<String, dynamic>;

            return _buildDriverRow(
              context,
              d,
              index,
              scaleMax,
            );
          },
        );
      },
    );
  }

  // ============================================================
  // JEDEN ŘÁDEK ŽEBŘÍČKU
  // ============================================================

  Widget _buildDriverRow(
    BuildContext context,
    Map<String, dynamic> data,
    int index,
    double scaleMax,
  ) {
    final colors =
        Theme.of(context)
            .colorScheme;

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final double totalKm =
        _toDouble(
      data['total_km'] ?? 0,
    );

    final double trainingKm =
        _toDouble(
      data['training_km'] ?? 0,
    );

    final String name =
        data['name'] ??
            'Neznámý strojvedoucí';

    final String lastVehicle =
        data['last_vehicle'] ??
            'Neznámo';

    final double fraction =
        (totalKm / scaleMax)
            .clamp(0.0, 1.0);

    final bool isFirst =
        index == 0;

    final Color rankColor =
        index == 0
            ? Colors.amber.shade700
            : index == 1
                ? Colors.grey.shade500
                : index == 2
                    ? Colors.brown.shade400
                    : colors
                        .onSurfaceVariant;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(14),

      decoration:
          BoxDecoration(
        color: colors.surface,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: isFirst
              ? Colors.amber
                  .withOpacity(
                  0.30,
                )
              : colors.outlineVariant
                  .withOpacity(
                  0.45,
                ),
        ),

        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.035,
                  ),
                  blurRadius: 10,
                  offset:
                      const Offset(
                    0,
                    3,
                  ),
                ),
              ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ==================================================
          // POŘADÍ
          // ==================================================

          SizedBox(
            width: 38,

            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,

                  decoration:
                      BoxDecoration(
                    color: rankColor
                        .withOpacity(
                      0.12,
                    ),
                    shape:
                        BoxShape.circle,
                  ),

                  alignment:
                      Alignment.center,

                  child: Text(
                    '${index + 1}',

                    style:
                        TextStyle(
                      color:
                          rankColor,
                      fontSize:
                          15,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          // ==================================================
          // OBSAH
          // ==================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Expanded(
                      child:
                          Text(
                        name,

                        maxLines:
                            2,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .w800,
                          fontSize:
                              15,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Flexible(
                      child:
                          Text(
                        lastVehicle,

                        maxLines:
                            2,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        textAlign:
                            TextAlign
                                .right,

                        style:
                            TextStyle(
                          fontSize:
                              10,
                          color:
                              colors
                                  .onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

                // ==================================================
                // GRAF
                // ==================================================

                LayoutBuilder(
                  builder:
                      (context,
                          constraints) {
                    final double
                        safeFraction =
                        fraction
                            .clamp(
                      0.0,
                      1.0,
                    );

                    return Stack(
                      children: [
                        Container(
                          height: 28,
                          width:
                              double.infinity,

                          decoration:
                              BoxDecoration(
                            color: colors
                                .surfaceContainerHighest,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                        ),

                        FractionallySizedBox(
                          widthFactor:
                              safeFraction,

                          child:
                              Container(
                            height: 28,

                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                colors:
                                    isFirst
                                        ? [
                                            Colors.amber
                                                .shade400,
                                            Colors.orange
                                                .shade600,
                                          ]
                                        : [
                                            Colors.blue
                                                .shade300,
                                            Colors.blue
                                                .shade700,
                                          ],
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 28,

                          child:
                              Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 10,
                            ),

                            child:
                                Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [
                                Expanded(
                                  child:
                                      trainingKm >
                                              0
                                          ? Text(
                                              'Zácvik: '
                                              '${_formatNumber(trainingKm)} km',

                                              overflow:
                                                  TextOverflow
                                                      .ellipsis,

                                              style:
                                                  TextStyle(
                                                fontSize:
                                                    10,

                                                fontWeight:
                                                    FontWeight
                                                        .w600,

                                                color:
                                                    safeFraction >
                                                            0.35
                                                        ? Colors
                                                            .white
                                                        : colors
                                                            .onSurfaceVariant,
                                              ),
                                            )
                                          : const SizedBox(),
                                ),

                                const SizedBox(
                                  width:
                                      8,
                                ),

                                Text(
                                  '${_formatNumber(totalKm)} km',

                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w800,

                                    fontSize:
                                        12,

                                    color:
                                        safeFraction >
                                                0.50
                                            ? Colors
                                                .white
                                            : colors
                                                .onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRÁZDNÝ ŽEBŘÍČEK
  // ============================================================

  Widget _buildEmptyLeaderboard() {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 70,
              height: 70,

              decoration:
                  BoxDecoration(
                color: colors
                    .surfaceContainerHighest,

                shape:
                    BoxShape.circle,
              ),

              child:
                  Icon(
                Icons
                    .emoji_events_outlined,

                size: 36,

                color: colors
                    .onSurfaceVariant,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            const Text(
              'Zatím nejsou zapsáni '
              'žádní strojvedoucí.',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              'Po prvním zápisu se zde '
              'zobrazí žebříček.',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color: colors
                    .onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PŘEVOD NA DOUBLE
  // ============================================================

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }
}