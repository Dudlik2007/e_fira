import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({super.key});

  @override
  State<LicenseScreen> createState() =>
      _LicenseScreenState();
}

class _LicenseScreenState
    extends State<LicenseScreen> {
  late Timer _timer;

  DateTime _currentTime =
      DateTime.now();

  String _driverName = "Nenastaveno";
  String _licenseNumber = "---";

  List<String> _unlockedVehicles = [];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadDriverData();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        setState(() {
          _currentTime =
              DateTime.now();
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ============================================================
  // NAČTENÍ DAT
  // ============================================================

  Future<void> _loadDriverData() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    if (!mounted) return;

    setState(() {
      _driverName =
          prefs.getString(
                'driverName',
              ) ??
              'Jan Novák';

      _licenseNumber =
          prefs.getString(
                'licenseNumber',
              ) ??
              '000000';

      _unlockedVehicles =
          prefs.getStringList(
                'unlockedVehicles',
              ) ??
              [];
    });
  }

  // ============================================================
  // POMOCNÉ FUNKCE
  // ============================================================

  String _formatDateTime(
      DateTime dt) {
    final d = dt.day
        .toString()
        .padLeft(2, '0');

    final m = dt.month
        .toString()
        .padLeft(2, '0');

    final y =
        dt.year.toString();

    final h = dt.hour
        .toString()
        .padLeft(2, '0');

    final min = dt.minute
        .toString()
        .padLeft(2, '0');

    final s = dt.second
        .toString()
        .padLeft(2, '0');

    return '$d-$m-$y | $h:$min:$s';
  }

  bool _hasLicense(
      String vehicleKey) {
    return _unlockedVehicles
        .contains(vehicleKey);
  }

  // ============================================================
  // AUTOBUS – DOČASNĚ NEDOSTUPNÉ
  // ============================================================

  void _showBusUnavailableDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          title: const Row(
            children: [
              Icon(
                Icons
                    .directions_bus_outlined,
                color: Colors.grey,
              ),

              SizedBox(width: 10),

              Text(
                'Nedostupné',
              ),
            ],
          ),

          content: const Text(
            'Tato volba je dočasně '
            'nedostupná a jednotka '
            'dočastnosti = 1 furt.',
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
              ),

              child:
                  const Text('Zavřít'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context) {
    final colors =
        Theme.of(context)
            .colorScheme;

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final bool hasD1 =
        _hasLicense(
      'D1_ZPUSOBILOST',
    );

    final bool hasCreatorPerk =
        _hasLicense(
      'PERK_CREATOR',
    );

    return Scaffold(
      backgroundColor:
          colors.surface,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        title: const Text(
          'Digitální průkaz',
          style: TextStyle(
            fontWeight:
                FontWeight.w700,
          ),
        ),

        backgroundColor:
            const Color(0xFF1B1B3A),

        foregroundColor:
            Colors.white,

        elevation: 0,
      ),

      // ========================================================
      // OBSAH
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          padding:
              const EdgeInsets.only(
            bottom: 30,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 760,
              ),

              child: Column(
                children: [
                  // ==================================================
                  // STAV + ČAS
                  // ==================================================

                  _buildStatusBar(
                    context,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ==================================================
                  // PRŮKAZ
                  // ==================================================

                  _buildLicenseCard(
                    context,
                    isDark,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // OPRÁVNĚNÍ
                  // ==================================================

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 20,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        // ==========================================
                        // TAJNÝ PERK
                        // ==========================================

                        if (hasCreatorPerk) ...[
                          _buildCreatorPerkCard(),

                          const SizedBox(
                            height: 18,
                          ),
                        ],

                        // ==========================================
                        // D1
                        // ==========================================

                        _buildD1Card(
                          context,
                          hasD1,
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        const Text(
                          'ŘIDIČSKÁ OPRÁVNĚNÍ',
                          style:
                              TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing:
                                0.5,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Divider(
                          thickness: 1.5,
                          color: colors
                              .outlineVariant,
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        // ==========================================
                        // VLAK
                        // ==========================================

                        _buildCategoryHeader(
                          context,
                          'VLAK',
                          Icons.train_outlined,
                        ),

                        _buildVehicleRow(
                          context,
                          '193 / 383 (Vectron)',
                          _hasLicense(
                            'VECTRON',
                          ),
                        ),

                        _buildVehicleRow(
                          context,
                          '854 (Hydra na steroidech)',
                          _hasLicense(
                            '854',
                          ),
                        ),

                        _buildVehicleRow(
                          context,
                          '640 (Panter)',
                          _hasLicense(
                            '640',
                          ),
                        ),

                        _buildVehicleRow(
                          context,
                          'CityElefant',
                          _hasLicense(
                            '471',
                          ),
                        ),

                        _buildVehicleRow(
                          context,
                          'T478.1 (749 - Barča, Zamračená)',
                          _hasLicense(
                            '749',
                          ),
                        ),

                        Divider(
                          height: 28,
                          color: colors
                              .outlineVariant,
                        ),

                        // ==========================================
                        // TRAMVAJ
                        // ==========================================

                        _buildCategoryHeader(
                          context,
                          'TRAMVAJ',
                          Icons.tram_outlined,
                        ),

                        _buildVehicleRow(
                          context,
                          '52T',
                          _hasLicense(
                            '52T',
                          ),
                        ),

                        _buildVehicleRow(
                          context,
                          'KT8',
                          _hasLicense(
                            'KT8',
                          ),
                        ),

                        Divider(
                          height: 28,
                          color: colors
                              .outlineVariant,
                        ),

                        // ==========================================
                        // METRO
                        // ==========================================

                        _buildCategoryHeader(
                          context,
                          'METRO',
                          Icons.subway_outlined,
                        ),

                        _buildVehicleRow(
                          context,
                          'Souprava metra',
                          _hasLicense(
                            'METRO',
                          ),
                        ),

                        Divider(
                          height: 28,
                          color: colors
                              .outlineVariant,
                        ),

                        // ==========================================
                        // AUTOBUS
                        // ==========================================

                        _buildUnavailableBus(
                          context,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STAVOVÝ PANEL
  // ============================================================

  Widget _buildStatusBar(
      BuildContext context) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 13,
      ),

      decoration:
          const BoxDecoration(
        color: Color(0xFF1B1B3A),
      ),

      child: LayoutBuilder(
        builder:
            (context, constraints) {
          final bool compact =
              constraints.maxWidth <
                  430;

          if (compact) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    Container(
                      width: 10,
                      height: 10,

                      decoration:
                          const BoxDecoration(
                        color:
                            Colors.greenAccent,
                        shape:
                            BoxShape.circle,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    const Text(
                      'PLATNÝ',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  _formatDateTime(
                    _currentTime,
                  ),

                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    fontFamily:
                        'monospace',
                    fontSize:
                        12,
                  ),
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [
              const Row(
                children: [
                  Icon(
                    Icons.circle,
                    color:
                        Colors.greenAccent,
                    size: 11,
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  Text(
                    'PLATNÝ',
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),
                ],
              ),

              Text(
                _formatDateTime(
                  _currentTime,
                ),

                style:
                    const TextStyle(
                  color:
                      Colors.white70,
                  fontFamily:
                      'monospace',
                  fontSize:
                      12,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // HLAVNÍ KARTA PRŮKAZU
  // ============================================================

  Widget _buildLicenseCard(
    BuildContext context,
    bool isDark,
  ) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          20,
        ),

        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFE0F7FA),
            Color(0xFF26A69A),
          ],

          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(
              isDark
                  ? 0.35
                  : 0.14,
            ),

            blurRadius: 18,

            offset:
                const Offset(0, 7),
          ),
        ],
      ),

      child: Column(
        children: [
          // ======================================================
          // HLAVIČKA KARTY
          // ======================================================

          Container(
            padding:
                const EdgeInsets.all(
              16,
            ),

            decoration:
                BoxDecoration(
              color: isDark
                  ? const Color(
                      0xFFE8ECEF,
                    )
                  : Colors.white,

              borderRadius:
                  const BorderRadius
                      .only(
                topLeft:
                    Radius.circular(
                  20,
                ),

                topRight:
                    Radius.circular(
                  20,
                ),
              ),
            ),

            child: LayoutBuilder(
              builder:
                  (context,
                      constraints) {
                return Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFF26A69A,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          10,
                        ),
                      ),

                      child:
                          const Text(
                        'SIM',
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontWeight:
                              FontWeight
                                  .w900,
                          fontSize:
                              20,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                          Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            'PRŮKAZ STROJVEDOUCÍHO SIMULÁTORŮ',

                            maxLines:
                                2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w900,
                              fontSize:
                                  12,
                              color:
                                  Color(
                                0xFF1B1B3A,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 3,
                          ),

                          Text(
                            'Licence: $_licenseNumber',

                            style:
                                const TextStyle(
                              color:
                                  Colors
                                      .black54,
                              fontSize:
                                  11,
                              fontWeight:
                                  FontWeight
                                      .w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ======================================================
          // OBSAH
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.all(
              22,
            ),

            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 140,

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
                    ),

                    border:
                        Border.all(
                      color:
                          Colors.white,
                      width: 3,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .black
                            .withOpacity(
                          0.10,
                        ),

                        blurRadius:
                            8,
                      ),
                    ],
                  ),
                  child:
                      ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(
                      7,
                    ),

                    child:
                        Image.asset(
                      'assets/user/user_licence_pass.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Text(
                  _driverName,

                  textAlign:
                      TextAlign.center,

                  maxLines:
                      2,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style:
                      const TextStyle(
                    fontSize:
                        24,

                    fontWeight:
                        FontWeight
                            .w900,

                    color:
                        Color(
                      0xFF1B1B3A,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                const Text(
                  'SPŠD Masná, Praha',

                  style:
                      TextStyle(
                    fontSize:
                        14,
                    color:
                        Colors
                            .black87,
                    fontWeight:
                        FontWeight
                            .w500,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Digitální licence',
                  style:
                      TextStyle(
                    fontSize:
                        11,
                    color:
                        Colors
                            .black
                            .withOpacity(
                      0.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAJNÝ PERK
  // ============================================================

  Widget _buildCreatorPerkCard() {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Colors.amber,
            Colors.orange,
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          15,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.amber
                .withOpacity(
              0.20,
            ),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: const Row(
        children: [
          Icon(
            Icons.workspace_premium,
            color:
                Colors.white,
            size: 38,
          ),

          SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  'EXKLUZIVNÍ STATUS',
                  style:
                      TextStyle(
                    color:
                        Colors.white70,
                    fontSize:
                        10,
                    fontWeight:
                        FontWeight
                            .w800,
                    letterSpacing:
                        1,
                  ),
                ),

                SizedBox(
                  height: 2,
                ),

                Text(
                  'Tvůrce simulátorů',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontWeight:
                        FontWeight
                            .w900,
                    fontSize:
                        18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // D1
  // ============================================================

  Widget _buildD1Card(
    BuildContext context,
    bool hasD1,
  ) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration:
          BoxDecoration(
        color: hasD1
            ? Colors.green
                .withOpacity(
                0.10,
              )
            : colors
                .surfaceContainerHighest,

        borderRadius:
            BorderRadius.circular(
          15,
        ),

        border:
            Border.all(
          color: hasD1
              ? Colors.green
                  .withOpacity(
                  0.35,
                )
              : colors
                  .outlineVariant,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              color: hasD1
                  ? Colors.green
                      .withOpacity(
                      0.14,
                    )
                  : Colors.grey
                      .withOpacity(
                      0.12,
                    ),

              borderRadius:
                  BorderRadius
                      .circular(
                12,
              ),
            ),

            child:
                Icon(
              hasD1
                  ? Icons.verified
                  : Icons
                      .remove_circle_outline,

              color: hasD1
                  ? Colors.green
                  : Colors.grey,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child:
                Text(
              'Odborná způsobilost dle předpisu SŽ D1',

              style:
                  TextStyle(
                fontWeight:
                    FontWeight
                        .w700,

                color: hasD1
                    ? Colors.green
                    : colors
                        .onSurfaceVariant,

                fontSize:
                    14,
              ),
            ),
          ),

          if (hasD1)
            const Icon(
              Icons.check_circle,
              color:
                  Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // HLAVIČKA KATEGORIE
  // ============================================================

  Widget _buildCategoryHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Padding(
      padding:
          const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration:
                BoxDecoration(
              color: colors
                  .primary
                  .withOpacity(
                0.10,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                12,
              ),
            ),

            child:
                Icon(
              icon,
              color:
                  colors.primary,
              size: 23,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Text(
            title,

            style:
                const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w800,
              letterSpacing:
                  0.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VOZIDLO
  // ============================================================

  Widget _buildVehicleRow(
    BuildContext context,
    String name,
    bool hasLicense,
  ) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 6,
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),

      decoration:
          BoxDecoration(
        color: hasLicense
            ? colors
                .primary
                .withOpacity(
                0.05,
              )
            : colors
                .surfaceContainerHighest,

        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),

      child: Row(
        children: [
          Icon(
            hasLicense
                ? Icons
                    .check_box
                : Icons
                    .check_box_outline_blank,

            color: hasLicense
                ? const Color(
                    0xFF26A69A,
                  )
                : colors
                    .onSurfaceVariant,

            size: 23,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              name,

              style:
                  TextStyle(
                fontSize:
                    14,

                color: hasLicense
                    ? colors
                        .onSurface
                    : colors
                        .onSurfaceVariant,

                fontWeight: hasLicense
                    ? FontWeight
                        .w700
                    : FontWeight
                        .w400,
              ),
            ),
          ),

          if (hasLicense)
            Icon(
              Icons.verified_outlined,
              color:
                  Colors
                      .green
                      .shade700,
              size: 19,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // AUTOBUS
  // ============================================================

  Widget _buildUnavailableBus(
      BuildContext context) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap:
            _showBusUnavailableDialog,

        borderRadius:
            BorderRadius.circular(
          14,
        ),

        child: Container(
          width:
              double.infinity,

          padding:
              const EdgeInsets.all(
            14,
          ),

          decoration:
              BoxDecoration(
            color: colors
                .surfaceContainerHighest
                .withOpacity(
              0.55,
            ),

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration:
                    BoxDecoration(
                  color: Colors
                      .grey
                      .withOpacity(
                    0.12,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),

                child:
                    const Icon(
                  Icons
                      .directions_bus_outlined,

                  color:
                      Colors.grey,
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
                      'AUTOBUS',
                      style:
                          TextStyle(
                        fontSize:
                            16,
                        fontWeight:
                            FontWeight
                                .w800,
                        color:
                            Colors.grey,
                      ),
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    Text(
                      'Tato možnost je dočasně nedostupná.',

                      style:
                          TextStyle(
                        fontSize:
                            11,
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors
                      .grey
                      .withOpacity(
                    0.15,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    10,
                  ),
                ),

                child:
                    const Text(
                  'NEDOSTUPNÉ',
                  style:
                      TextStyle(
                    fontSize:
                        9,
                    fontWeight:
                        FontWeight
                            .w800,
                    color:
                        Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}