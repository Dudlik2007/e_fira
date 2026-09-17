import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ============================================================
  // NASTAVENÍ
  // ============================================================

  bool _skipWelcome = false;
  bool _darkMode = false;

  // Osobní údaje průkazu
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _licenseController =
      TextEditingController();

  final TextEditingController _codeController =
      TextEditingController();

  List<String> _unlockedVehicles = [];

  // ============================================================
  // DOSTUPNÁ OPRÁVNĚNÍ
  // ============================================================

  final Map<String, String> _availableVehicles = {
    'PERK_CREATOR':
        'Tvůrce simulátorů (Skrytý Perk)',
    'D1_ZPUSOBILOST':
        'Odborná způsobilost SŽ D1',
    'VECTRON':
        '193 / 383 (Vectron)',
    '854':
        '854 (Hydra na steroidech)',
    '640':
        '640 (Panter)',
    '471':
        'CityElefant',
    '749':
        'T478.1 (749 - Barča, Zamračená)',
    '52T':
        '52T (Tramvaj)',
    'KT8':
        'KT8 (Tramvaj)',
    'METRO':
        'Souprava metra',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // ============================================================
  // NAČTENÍ NASTAVENÍ
  // ============================================================

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    final darkMode =
        prefs.getBool('darkMode') ?? false;

    setState(() {
      _skipWelcome =
          prefs.getBool('skipWelcome') ?? false;

      _darkMode = darkMode;

      _nameController.text =
          prefs.getString('driverName') ?? '';

      _licenseController.text =
          prefs.getString('licenseNumber') ?? '';

      _unlockedVehicles =
          prefs.getStringList('unlockedVehicles') ?? [];
    });

    appDarkMode.value = darkMode;
  }

  // ============================================================
  // PŘESKOČIT UVÍTÁNÍ
  // ============================================================

  Future<void> _toggleSkipWelcome(
      bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'skipWelcome',
      value,
    );

    if (!mounted) return;

    setState(() {
      _skipWelcome = value;
    });
  }

  // ============================================================
  // DARK MODE
  // ============================================================

  Future<void> _toggleDarkMode(
      bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'darkMode',
      value,
    );

    // Okamžitá změna celého tématu aplikace
    appDarkMode.value = value;

    if (!mounted) return;

    setState(() {
      _darkMode = value;
    });
  }

  // ============================================================
  // OSOBNÍ ÚDAJE
  // ============================================================

  Future<void> _savePersonalData() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'driverName',
      _nameController.text.trim(),
    );

    await prefs.setString(
      'licenseNumber',
      _licenseController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Údaje průkazu byly uloženy.'),
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
  // GENEROVÁNÍ BEZPEČNOSTNÍHO KÓDU
  // ============================================================

  String _generateSecurityCode(
    String license,
    String vehicleKey,
  ) {
    const String secretSalt =
        "MasnaSim2026";

    final String input =
        "$license-$vehicleKey-$secretSalt";

    int hash = 5381;

    for (int i = 0;
        i < input.length;
        i++) {
      hash =
          ((hash << 5) + hash) +
              input.codeUnitAt(i);
    }

    return hash
        .toUnsigned(32)
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2, 8)
        .toUpperCase();
  }

  // ============================================================
  // ZPRACOVÁNÍ KÓDU
  // ============================================================

  Future<void> _redeemCode() async {
    final enteredCode =
        _codeController.text
            .trim()
            .toUpperCase();

    final currentLicense =
        _licenseController.text.trim();

    // ==========================================================
    // MASTER KÓD
    // ==========================================================

    if (enteredCode == 'MASNA-ALL') {
      final prefs =
          await SharedPreferences.getInstance();

      final List<String> newUnlocks =
          _availableVehicles.keys
              .where(
                (k) => k != 'PERK_CREATOR',
              )
              .toList();

      // Tajný perk se nesmaže
      if (_unlockedVehicles.contains(
          'PERK_CREATOR')) {
        newUnlocks.add('PERK_CREATOR');
      }

      _unlockedVehicles =
          newUnlocks;

      await prefs.setStringList(
        'unlockedVehicles',
        _unlockedVehicles,
      );

      if (!mounted) return;

      setState(() {});

      _codeController.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: const Text(
            'MASTER KÓD PŘIJAT: '
            'Všechna běžná oprávnění odemčena!',
          ),
          backgroundColor:
              Colors.purple,
          behavior:
              SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // KONTROLA LICENCE
    // ==========================================================

    if (currentLicense.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Nejprve si uložte číslo licence.',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );

      return;
    }

    bool codeValid = false;
    String? unlockedVehicleName;
    String? unlockedVehicleKey;

    // ==========================================================
    // HLEDÁNÍ OPRÁVNĚNÍ
    // ==========================================================

    for (final entry
        in _availableVehicles.entries) {
      final expectedCode =
          _generateSecurityCode(
        currentLicense,
        entry.key,
      );

      if (enteredCode == expectedCode) {
        codeValid = true;
        unlockedVehicleKey =
            entry.key;
        unlockedVehicleName =
            entry.value;
        break;
      }
    }

    // ==========================================================
    // PLATNÝ KÓD
    // ==========================================================

    if (codeValid &&
        unlockedVehicleKey != null) {
      if (_unlockedVehicles
          .contains(unlockedVehicleKey)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Toto oprávnění už máte.',
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );

        return;
      }

      final prefs =
          await SharedPreferences
              .getInstance();

      _unlockedVehicles
          .add(unlockedVehicleKey);

      await prefs.setStringList(
        'unlockedVehicles',
        _unlockedVehicles,
      );

      if (!mounted) return;

      setState(() {});

      _codeController.clear();

      // ========================================================
      // TAJNÝ PERK
      // ========================================================

      if (unlockedVehicleKey ==
          'PERK_CREATOR') {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: const Text(
              'ZLATÝ PERK ODEMČEN: '
              'Tvůrce simulátorů!',
            ),
            backgroundColor:
                Colors.amber.shade800,
            behavior:
                SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Odemčeno: '
              '$unlockedVehicleName!',
            ),
            backgroundColor:
                Colors.green.shade700,
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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Neplatný kód. '
            'Zkontrolujte číslo licence.',
          ),
          backgroundColor:
              Colors.red,
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // ADMIN GENERÁTOR
  // ============================================================

  void _showAdminGenerator() {
    String selectedVehicle =
        _availableVehicles.keys.first;

    final TextEditingController
        adminLicenseCtrl =
        TextEditingController(
      text: _licenseController.text,
    );

    String generatedCode = "";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              scrollable: true,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(22),
              ),

              title: const Row(
                children: [
                  Icon(
                    Icons
                        .admin_panel_settings,
                    color: Colors.red,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Admin: Generátor kódů',
                    ),
                  ),
                ],
              ),

              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  TextField(
                    controller:
                        adminLicenseCtrl,

                    textInputAction:
                        TextInputAction.next,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Číslo průkazu žáka',

                      prefixIcon:
                          const Icon(
                        Icons.badge_outlined,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  DropdownButtonFormField<
                      String>(
                    value: selectedVehicle,

                    isExpanded: true,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Oprávnění',

                      prefixIcon:
                          const Icon(
                        Icons.train_outlined,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    items:
                        _availableVehicles
                            .entries
                            .map(
                      (e) {
                        return DropdownMenuItem(
                          value: e.key,

                          child: Text(
                            e.value,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        selectedVehicle =
                            value;
                        generatedCode = "";
                      });
                    },
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton.icon(
                      onPressed: () {
                        final license =
                            adminLicenseCtrl
                                .text
                                .trim();

                        if (license.isEmpty) {
                          return;
                        }

                        setDialogState(() {
                          generatedCode =
                              _generateSecurityCode(
                            license,
                            selectedVehicle,
                          );
                        });
                      },

                      icon: const Icon(
                        Icons.vpn_key,
                      ),

                      label: const Text(
                        'Generovat kód',
                      ),

                      style:
                          ElevatedButton
                              .styleFrom(
                        minimumSize:
                            const Size
                                .fromHeight(
                          48,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(14),
                        ),
                      ),
                    ),
                  ),

                  if (generatedCode
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 18,
                    ),

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets
                              .all(18),

                      decoration:
                          BoxDecoration(
                        color: Colors.red
                            .withOpacity(
                          0.06,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(16),

                        border:
                            Border.all(
                          color: Colors.red
                              .withOpacity(
                            0.15,
                          ),
                        ),
                      ),

                      child: Column(
                        children: [
                          const Text(
                            'Vygenerovaný kód',

                            style:
                                TextStyle(
                              fontSize: 12,
                              color:
                                  Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          SelectableText(
                            generatedCode,

                            textAlign:
                                TextAlign
                                    .center,

                            style:
                                const TextStyle(
                              fontSize: 27,
                              fontWeight:
                                  FontWeight
                                      .w800,
                              letterSpacing:
                                  3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
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
      },
    );
  }

  // ============================================================
  // VYMAZÁNÍ DAT
  // ============================================================

  Future<void> _deleteLocalData() async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Text(
            'Vymazat lokální data?',
          ),

          content: const Text(
            'Tímto se smaže jméno, číslo '
            'licence a všechna odemčená '
            'oprávnění.\n\n'
            'Tato akce nejde vrátit zpět.',
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),

              child:
                  const Text('Zrušit'),
            ),

            FilledButton(
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),

              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),

              child:
                  const Text('Vymazat'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove('driverName');
    await prefs.remove('licenseNumber');
    await prefs.remove(
        'unlockedVehicles');

    if (!mounted) return;

    setState(() {
      _nameController.clear();
      _licenseController.clear();
      _unlockedVehicles.clear();
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Všechna data průkazu byla vymazána.',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        title: GestureDetector(
          onLongPress:
              _showAdminGenerator,

          child: const Text(
            'Centrální nastavení',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),

        centerTitle: false,
        elevation: 0,
      ),

      // ========================================================
      // OBSAH
      // ========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) {
            final contentWidth =
                constraints.maxWidth > 720
                    ? 680.0
                    : constraints.maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(
                  maxWidth:
                      contentWidth,
                ),

                child: ListView(
                  physics:
                      const BouncingScrollPhysics(),

                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  children: [
                    // ==================================================
                    // ÚVOD
                    // ==================================================

                    _buildIntroCard(),

                    const SizedBox(
                      height: 14,
                    ),

                    // ==================================================
                    // OBECNÉ NASTAVENÍ
                    // ==================================================

                    _buildSectionCard(
                      icon: Icons.tune,
                      color:
                          Colors.blue,
                      title:
                          'Obecné nastavení',

                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding:
                                EdgeInsets.zero,

                            secondary: Icon(
                              _skipWelcome
                                  ? Icons
                                      .home_outlined
                                  : Icons.home,
                            ),

                            title:
                                const Text(
                              'Přeskočit uvítací obrazovku',
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),

                            subtitle:
                                const Text(
                              'Při příštím spuštění se '
                              'otevře rovnou výběr vlaku.',
                            ),

                            value:
                                _skipWelcome,

                            onChanged:
                                _toggleSkipWelcome,
                          ),

                          const Divider(
                            height: 1,
                          ),

                          SwitchListTile(
                            contentPadding:
                                EdgeInsets.zero,

                            secondary: Icon(
                              _darkMode
                                  ? Icons
                                      .dark_mode_outlined
                                  : Icons
                                      .light_mode_outlined,
                            ),

                            title:
                                const Text(
                              'Tmavý režim',
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),

                            subtitle:
                                Text(
                              _darkMode
                                  ? 'Používá se tmavé barevné schéma.'
                                  : 'Používá se světlé barevné schéma.',
                            ),

                            value:
                                _darkMode,

                            onChanged:
                                _toggleDarkMode,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ==================================================
                    // OSOBNÍ ÚDAJE
                    // ==================================================

                    _buildSectionCard(
                      icon:
                          Icons.badge_outlined,

                      color:
                          const Color(
                        0xFF1B1B3A,
                      ),

                      title:
                          'Osobní údaje průkazu',

                      child: Column(
                        children: [
                          _buildTextField(
                            controller:
                                _nameController,

                            label:
                                'Jméno strojvedoucího',

                            hint:
                                'Např. Jan Novák',

                            icon:
                                Icons
                                    .person_outline,

                            textInputAction:
                                TextInputAction
                                    .next,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          _buildTextField(
                            controller:
                                _licenseController,

                            label:
                                'Číslo licence / průkazu',

                            hint:
                                'Např. MASNA-12345',

                            icon:
                                Icons
                                    .badge_outlined,
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          SizedBox(
                            width:
                                double.infinity,

                            child:
                                FilledButton.icon(
                              onPressed:
                                  _savePersonalData,

                              icon:
                                  const Icon(
                                Icons
                                    .save_outlined,
                              ),

                              label:
                                  const Text(
                                'Uložit osobní údaje',
                              ),

                              style:
                                  FilledButton
                                      .styleFrom(
                                minimumSize:
                                    const Size
                                        .fromHeight(
                                  48,
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ==================================================
                    // ODEMKNUTÍ
                    // ==================================================

                    _buildSectionCard(
                      icon:
                          Icons.key_outlined,

                      color:
                          Colors.green.shade700,

                      title:
                          'Získání nového oprávnění',

                      subtitle:
                          'Kód od instruktora přidá oprávnění '
                          'do tvého průkazu.',

                      child: Column(
                        children: [
                          _buildTextField(
                            controller:
                                _codeController,

                            label:
                                'Kód od instruktora',

                            hint:
                                'Zadejte přístupový kód',

                            icon:
                                Icons
                                    .vpn_key_outlined,

                            textCapitalization:
                                TextCapitalization
                                    .characters,

                            onSubmitted:
                                (_) =>
                                    _redeemCode(),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          SizedBox(
                            width:
                                double.infinity,

                            child:
                                FilledButton.icon(
                              onPressed:
                                  _redeemCode,

                              icon:
                                  const Icon(
                                Icons
                                    .lock_open_outlined,
                              ),

                              label:
                                  const Text(
                                'Ověřit kód a odemknout',
                              ),

                              style:
                                  FilledButton
                                      .styleFrom(
                                backgroundColor:
                                    Colors
                                        .green
                                        .shade700,

                                foregroundColor:
                                    Colors.white,

                                minimumSize:
                                    const Size
                                        .fromHeight(
                                  48,
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ==================================================
                    // OPRÁVNĚNÍ
                    // ==================================================

                    _buildSectionCard(
                      icon:
                          Icons.train_outlined,

                      color:
                          Colors.blueGrey
                              .shade700,

                      title:
                          'Vaše aktuální oprávnění',

                      subtitle:
                          _unlockedVehicles
                                  .isEmpty
                              ? 'Zatím nemáte odemčena '
                                  'žádná oprávnění.'
                              : '${_unlockedVehicles.length} '
                                  'odemčených oprávnění',

                      child:
                          _buildVehiclesList(),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ==================================================
                    // NEBEZPEČNÁ ZÓNA
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Theme.of(
                          context,
                        )
                            .colorScheme
                            .surface,

                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        border:
                            Border.all(
                          color: Colors.red
                              .withOpacity(
                            0.18,
                          ),
                        ),

                        boxShadow: dark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                    0.04,
                                  ),
                                  blurRadius: 12,
                                  offset:
                                      const Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,

                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .red
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
                                    const Icon(
                                  Icons
                                      .warning_amber_rounded,
                                  color:
                                      Colors.red,
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
                                      'Nebezpečná zóna',
                                      style:
                                          TextStyle(
                                        fontSize:
                                            17,
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 2,
                                    ),

                                    Text(
                                      'Akce, které mohou smazat data.',
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
                            ],
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          Material(
                            color: Colors.red
                                .withOpacity(
                              0.06,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),

                            child:
                                InkWell(
                              onTap:
                                  _deleteLocalData,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),

                              child:
                                  Padding(
                                padding:
                                    const EdgeInsets
                                        .all(
                                  14,
                                ),

                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .delete_forever_outlined,
                                      color:
                                          Colors.red,
                                    ),

                                    const SizedBox(
                                      width: 14,
                                    ),

                                    const Expanded(
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            'Vymazat lokální data',
                                            style:
                                                TextStyle(
                                              color:
                                                  Colors.red,
                                              fontWeight:
                                                  FontWeight
                                                      .w700,
                                            ),
                                          ),

                                          SizedBox(
                                            height:
                                                3,
                                          ),

                                          Text(
                                            'Smaže jméno, licenci '
                                            'a všechna oprávnění.',
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

                                    const Icon(
                                      Icons
                                          .chevron_right,
                                      color:
                                          Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // ==================================================
                    // PATIČKA
                    // ==================================================

                    Center(
                      child: Text(
                        'Zpráva o brzdění • Nastavení',
                        style:
                            TextStyle(
                          color: Theme.of(
                            context,
                          )
                              .colorScheme
                              .onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // ÚVODNÍ KARTA
  // ============================================================

  Widget _buildIntroCard() {
    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
          ],

          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.blue
                .withOpacity(0.22),

            blurRadius: 18,

            offset:
                const Offset(0, 7),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,

            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withOpacity(
                0.16,
              ),

              borderRadius:
                  BorderRadius
                      .circular(16),
            ),

            child:
                const Icon(
              Icons.settings_outlined,
              color:
                  Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Nastavení aplikace',

                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  'Správa průkazu, oprávnění '
                  'a chování aplikace.',

                  style:
                      TextStyle(
                    color:
                        Colors.white70,
                    fontSize:
                        12,
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
  // SEKCE
  // ============================================================

  Widget _buildSectionCard({
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.045,
                  ),
                  blurRadius: 13,
                  offset:
                      const Offset(0, 5),
                ),
              ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Container(
                width: 44,
                height: 44,

                decoration:
                    BoxDecoration(
                  color: color
                      .withOpacity(
                    0.10,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    13,
                  ),
                ),

                child:
                    Icon(
                  icon,
                  color:
                      color,
                  size: 23,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      title,

                      style:
                          const TextStyle(
                        fontSize:
                            17,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),

                    if (subtitle !=
                        null) ...[
                      const SizedBox(
                        height: 3,
                      ),

                      Text(
                        subtitle,

                        style:
                            TextStyle(
                          color: Theme.of(
                            context,
                          )
                              .colorScheme
                              .onSurfaceVariant,
                          fontSize:
                              12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller:
          controller,

      textInputAction:
          textInputAction,

      textCapitalization:
          textCapitalization,

      onSubmitted:
          onSubmitted,

      decoration:
          InputDecoration(
        labelText:
            label,

        hintText:
            hint,

        prefixIcon:
            Icon(icon),

        filled:
            true,

        fillColor:
            Theme.of(context)
                .colorScheme
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

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),

          borderSide:
              BorderSide(
            color: Theme.of(
              context,
            )
                .colorScheme
                .outline
                .withOpacity(
              0.15,
            ),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),

          borderSide:
              const BorderSide(
            color:
                Colors.blue,
            width:
                1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SEZNAM OPRÁVNĚNÍ
  // ============================================================

  Widget _buildVehiclesList() {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    if (_unlockedVehicles.isEmpty) {
      return Container(
        width:
            double.infinity,

        padding:
            const EdgeInsets.all(18),

        decoration:
            BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest,

          borderRadius:
              BorderRadius.circular(
            15,
          ),
        ),

        child: Row(
          children: [
            Icon(
              Icons.lock_outline,
              color:
                  Colors.grey.shade500,
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Text(
                'Zatím nemáte odemčeno '
                'žádné vozidlo.',

                style: TextStyle(
                  color: Theme.of(
                    context,
                  )
                      .colorScheme
                      .onSurfaceVariant,

                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ..._unlockedVehicles.map(
          (vKey) {
            final bool isPerk =
                vKey ==
                    'PERK_CREATOR';

            return Container(
              margin:
                  const EdgeInsets.only(
                bottom: 8,
              ),

              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 12,
                vertical: 10,
              ),

              decoration:
                  BoxDecoration(
                color: isPerk
                    ? Colors.amber
                        .withOpacity(
                        dark
                            ? 0.14
                            : 0.08,
                      )
                    : Theme.of(
                        context,
                      )
                        .colorScheme
                        .surfaceContainerHighest,

                borderRadius:
                    BorderRadius
                        .circular(
                  14,
                ),

                border: isPerk
                    ? Border.all(
                        color: Colors
                            .amber
                            .withOpacity(
                          0.30,
                        ),
                      )
                    : null,
              ),

              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,

                    decoration:
                        BoxDecoration(
                      color: isPerk
                          ? Colors.amber
                              .withOpacity(
                              0.16,
                            )
                          : Colors.green
                              .withOpacity(
                              0.10,
                            ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        11,
                      ),
                    ),

                    child:
                        Icon(
                      isPerk
                          ? Icons
                              .workspace_premium
                          : Icons
                              .check_circle_outline,

                      color: isPerk
                          ? Colors
                              .amber
                              .shade800
                          : Colors
                              .green
                              .shade700,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Text(
                      _availableVehicles[
                              vKey] ??
                          vKey,

                      style:
                          TextStyle(
                        fontWeight: isPerk
                            ? FontWeight
                                .w800
                            : FontWeight
                                .w600,

                        fontSize:
                            14,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.verified,

                    size: 18,

                    color: isPerk
                        ? Colors
                            .amber
                            .shade800
                        : Colors
                            .green
                            .shade700,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}