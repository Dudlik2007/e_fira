import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

// Sem později přidáš import tvého DatabaseUpdateru:
// import 'package:e_fira/database/database_updater.dart';

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
  bool _darkMode = true;

  // Osobní údaje průkazu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  
  // Databáze
  final TextEditingController _dbUrlController = TextEditingController(); // NOVÉ: URL databáze

  // ============================================================
  // ŽEBŘÍČEK A FILTROVÁNÍ
  // ============================================================
  
  String _leaderboardFilter = 'all'; // 'all', 'range', 'specific'
  final TextEditingController _rangeFromCtrl = TextEditingController();
  final TextEditingController _rangeToCtrl = TextEditingController();
  
  List<String> _specificLicenses = [];
  String? _selectedDbLicense;

  // MOCK DATABÁZE
  final List<String> _dbLicensesMock = [
    '10124',
    '10125',
    '10126',
    '10127',
    '10128',
    '10129',
    '330448',
    '330447',
  ];

  List<String> _unlockedVehicles = [];

  // ============================================================
  // DOSTUPNÁ OPRÁVNĚNÍ
  // ============================================================

  final Map<String, String> _availableVehicles = {
    'PERK_CREATOR': 'Tvůrce simulátorů (Skrytý Perk)',
    'D1_ZPUSOBILOST': 'Odborná způsobilost SŽ D1',
    'VECTRON': '193 / 383 (Vectron)',
    '854': '854 (Hydra na steroidech)',
    '640': '640 (Panter)',
    '471': 'CityElefant',
    '749': 'T478.1 (749 - Barča, Zamračená)',
    '52T': '52T (Tramvaj)',
    'KT8': 'KT8 (Tramvaj)',
    'METRO': 'Souprava metra',
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
    _dbUrlController.dispose(); // NOVÉ
    _rangeFromCtrl.dispose();
    _rangeToCtrl.dispose();
    super.dispose();
  }

  // ============================================================
  // NAČTENÍ NASTAVENÍ
  // ============================================================

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final darkMode = prefs.getBool('darkMode') ?? true;

    setState(() {
      _skipWelcome = prefs.getBool('skipWelcome') ?? false;
      _darkMode = darkMode;

      _nameController.text = prefs.getString('driverName') ?? '';
      _licenseController.text = prefs.getString('licenseNumber') ?? '';
      
      // NOVÉ: Načtení uložené URL
      _dbUrlController.text = prefs.getString('server_database_url') ?? '';

      // Načtení filtrů žebříčku
      _leaderboardFilter = prefs.getString('leaderboardFilter') ?? 'all';
      _rangeFromCtrl.text = prefs.getString('filterRangeFrom') ?? '';
      _rangeToCtrl.text = prefs.getString('filterRangeTo') ?? '';
      _specificLicenses = prefs.getStringList('filterSpecific') ?? [];

      _unlockedVehicles = prefs.getStringList('unlockedVehicles') ?? [];
    });

    appDarkMode.value = darkMode;
  }

  // ============================================================
  // ULOŽENÍ A PŘEPÍNAČE
  // ============================================================

  Future<void> _toggleSkipWelcome(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipWelcome', value);
    if (!mounted) return;
    setState(() => _skipWelcome = value);
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    appDarkMode.value = value;
    if (!mounted) return;
    setState(() => _darkMode = value);
  }

  Future<void> _savePersonalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driverName', _nameController.text.trim());
    await prefs.setString('licenseNumber', _licenseController.text.trim());
    if (!mounted) return;
    _showSnackBar('Údaje průkazu byly uloženy.');
  }

  // NOVÉ: Funkce pro uložení URL a zavolání stahování
  Future<void> _saveAndDownloadDb() async {
    final url = _dbUrlController.text.trim();
    if (url.isEmpty) {
      _showSnackBar('Zadejte prosím URL adresu serveru.', color: Colors.red);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_database_url', url);

    _showSnackBar('URL uložena. Zahajuji stahování databáze...', color: Colors.blue);

    // Zde později odkomentuješ kód, který propojí UI s tvým DatabaseUpdaterem:
    /*
    String result = await DatabaseUpdater.downloadDatabaseFromServer();
    if (!mounted) return;
    
    if (result == 'success') {
      _showSnackBar('Databáze byla úspěšně stažena a je připravena.', color: Colors.green);
    } else {
      _showSnackBar(result, color: Colors.red);
    }
    */
  }

  Future<void> _saveLeaderboardSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('leaderboardFilter', _leaderboardFilter);
    await prefs.setString('filterRangeFrom', _rangeFromCtrl.text.trim());
    await prefs.setString('filterRangeTo', _rangeToCtrl.text.trim());
    await prefs.setStringList('filterSpecific', _specificLicenses);
    
    if (!mounted) return;
    _showSnackBar('Nastavení žebříčku uloženo.', color: Colors.orange.shade700);
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ============================================================
  // ZPRACOVÁNÍ OPRÁVNĚNÍ
  // ============================================================

  String _generateSecurityCode(String license, String vehicleKey) {
    const String secretSalt = "MasnaSim2026";
    final String input = "$license-$vehicleKey-$secretSalt";
    int hash = 5381;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) + hash) + input.codeUnitAt(i);
    }
    return hash.toUnsigned(32).toRadixString(16).padLeft(8, '0').substring(2, 8).toUpperCase();
  }

  Future<void> _redeemCode() async {
    final enteredCode = _codeController.text.trim().toUpperCase();
    final currentLicense = _licenseController.text.trim();

    if (enteredCode == 'MASNA-ALL') {
      final prefs = await SharedPreferences.getInstance();
      final List<String> newUnlocks = _availableVehicles.keys.where((k) => k != 'PERK_CREATOR').toList();
      if (_unlockedVehicles.contains('PERK_CREATOR')) newUnlocks.add('PERK_CREATOR');
      _unlockedVehicles = newUnlocks;
      await prefs.setStringList('unlockedVehicles', _unlockedVehicles);
      if (!mounted) return;
      setState(() => _codeController.clear());
      _showSnackBar('MASTER KÓD PŘIJAT: Všechna běžná oprávnění odemčena!', color: Colors.purple);
      return;
    }

    if (currentLicense.isEmpty) {
      _showSnackBar('Nejprve si uložte číslo licence.', color: Colors.red);
      return;
    }

    bool codeValid = false;
    String? unlockedVehicleKey;
    String? unlockedVehicleName;

    for (final entry in _availableVehicles.entries) {
      if (enteredCode == _generateSecurityCode(currentLicense, entry.key)) {
        codeValid = true;
        unlockedVehicleKey = entry.key;
        unlockedVehicleName = entry.value;
        break;
      }
    }

    if (codeValid && unlockedVehicleKey != null) {
      if (_unlockedVehicles.contains(unlockedVehicleKey)) {
        _showSnackBar('Toto oprávnění už máte.');
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      _unlockedVehicles.add(unlockedVehicleKey);
      await prefs.setStringList('unlockedVehicles', _unlockedVehicles);

      if (!mounted) return;
      setState(() => _codeController.clear());

      if (unlockedVehicleKey == 'PERK_CREATOR') {
        _showSnackBar('ZLATÝ PERK ODEMČEN: Tvůrce simulátorů!', color: Colors.amber.shade800);
      } else {
        _showSnackBar('Odemčeno: $unlockedVehicleName!', color: Colors.green.shade700);
      }
    } else {
      _showSnackBar('Neplatný kód. Zkontrolujte číslo licence.', color: Colors.red);
    }
  }

  Future<void> _deleteLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Vymazat lokální data?'),
        content: const Text('Tímto se smaže jméno, číslo licence a všechna odemčená oprávnění.\nTato akce nejde vrátit zpět.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Zrušit')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vymazat'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('driverName');
    await prefs.remove('licenseNumber');
    await prefs.remove('unlockedVehicles');
    await prefs.remove('server_database_url'); // NOVÉ: Přidal jsem smazání i u DB URL

    if (!mounted) return;
    setState(() {
      _nameController.clear();
      _licenseController.clear();
      _dbUrlController.clear();
      _unlockedVehicles.clear();
    });
    _showSnackBar('Všechna data průkazu byla vymazána.');
  }

  // ============================================================
  // BUILD & RESPONZIVNÍ ROZLOŽENÍ
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Centrální nastavení', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth >= 850;
            final double contentWidth = isDesktop ? 1200 : 680;

            final List<Widget> leftColumnContent = [
              _buildIntroCard(),
              const SizedBox(height: 14),
              _buildPersonalDataSection(),
              const SizedBox(height: 14),
              _buildLeaderboardSection(),
            ];

            final List<Widget> rightColumnContent = [
              _buildGeneralSettingsSection(),
              const SizedBox(height: 14),
              _buildDatabaseSection(), // NOVÉ: Sekce pro databázi přidána sem
              const SizedBox(height: 14),
              _buildUnlockSection(),
              const SizedBox(height: 14),
              _buildPermissionsSection(),
              const SizedBox(height: 14),
              _buildDangerZone(),
            ];

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Column(children: leftColumnContent)),
                                const SizedBox(width: 20),
                                Expanded(child: Column(children: rightColumnContent)),
                              ],
                            )
                          else
                            Column(
                              children: [
                                ...leftColumnContent,
                                const SizedBox(height: 14),
                                ...rightColumnContent,
                              ],
                            ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Zpráva o brzdění • Nastavení',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // KOMPONENTY PRO SEKCE
  // ============================================================

  Widget _buildGeneralSettingsSection() {
    return _buildSectionCard(
      icon: Icons.tune,
      color: Colors.blue,
      title: 'Obecné nastavení',
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(_skipWelcome ? Icons.home_outlined : Icons.home),
            title: const Text('Přeskočit uvítací obrazovku', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Při příštím spuštění se otevře rovnou výběr vlaku.'),
            value: _skipWelcome,
            onChanged: _toggleSkipWelcome,
          ),
          const Divider(height: 1),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(_darkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            title: const Text('Tmavý režim', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(_darkMode ? 'Používá se tmavé barevné schéma.' : 'Používá se světlé barevné schéma.'),
            value: _darkMode,
            onChanged: _toggleDarkMode,
          ),
        ],
      ),
    );
  }

  // NOVÉ: Vykreslení sekce pro databázi
  Widget _buildDatabaseSection() {
    return _buildSectionCard(
      icon: Icons.storage_outlined,
      color: Colors.purple,
      title: 'Zdroj dat (Databáze)',
      subtitle: 'Zadejte URL adresu pro stažení aktuálních jízdních dat.',
      child: Column(
        children: [
          _buildTextField(
            controller: _dbUrlController,
            label: 'URL adresa databáze (.sqlite)',
            hint: 'https://minibrzda.jednoduse.cz/data/databaze.sqlite',
            icon: Icons.link,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _saveAndDownloadDb(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(              onPressed: _saveAndDownloadDb,
              icon: const Icon(Icons.cloud_download_outlined),
              label: const Text('Uložit URL a stáhnout databázi'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataSection() {
    return _buildSectionCard(
      icon: Icons.badge_outlined,
      color: const Color(0xFF1B1B3A),
      title: 'Osobní údaje průkazu',
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Jméno strojvedoucího',
            hint: 'Např. Jan Novák',
            icon: Icons.person_outline,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _licenseController,
            label: 'Číslo licence / průkazu',
            hint: 'Např. MASNA-12345',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _savePersonalData,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Uložit osobní údaje'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    return _buildSectionCard(
      icon: Icons.leaderboard_outlined,
      color: Colors.orange.shade700,
      title: 'Žebříček kilometrů',
      subtitle: 'Filtr načítaných licencí do tabulky žebříčku.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown(
            value: _leaderboardFilter,
            label: 'Zobrazit v žebříčku',
            icon: Icons.filter_list,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Všechny načtené průkazy')),
              DropdownMenuItem(value: 'range', child: Text('Rozsah čísel (Od - Do)')),
              DropdownMenuItem(value: 'specific', child: Text('Pouze konkrétní vybrané průkazy')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _leaderboardFilter = val);
            },
          ),
          
          if (_leaderboardFilter == 'range') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _rangeFromCtrl,
                    label: 'Od',
                    hint: 'Např. 001',
                    icon: Icons.arrow_right_alt,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _rangeToCtrl,
                    label: 'Do',
                    hint: 'Např. 050',
                    icon: Icons.keyboard_tab,
                  ),
                ),
              ],
            ),
          ],

          if (_leaderboardFilter == 'specific') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    value: _selectedDbLicense ?? (_dbLicensesMock.isNotEmpty ? _dbLicensesMock.first : ''),
                    label: 'Načteno z databáze',
                    icon: Icons.cloud_download_outlined,
                    items: _dbLicensesMock.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      setState(() => _selectedDbLicense = val);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  color: Colors.blue,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final toAdd = _selectedDbLicense ?? (_dbLicensesMock.isNotEmpty ? _dbLicensesMock.first : null);
                    if (toAdd != null && !_specificLicenses.contains(toAdd)) {
                      setState(() => _specificLicenses.add(toAdd));
                    }
                  },
                ),
              ],
            ),
            if (_specificLicenses.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _specificLicenses.map((lic) => Chip(
                  label: Text(lic, style: const TextStyle(fontSize: 12)),
                  onDeleted: () => setState(() => _specificLicenses.remove(lic)),
                  deleteIconColor: Colors.red.shade300,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
                )).toList(),
              ),
            ]
          ],

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saveLeaderboardSettings,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Uložit nastavení filtru'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockSection() {
    return _buildSectionCard(
      icon: Icons.key_outlined,
      color: Colors.green.shade700,
      title: 'Získání nového oprávnění',
      subtitle: 'Kód od instruktora přidá oprávnění do tvého průkazu.',
      child: Column(
        children: [
          _buildTextField(
            controller: _codeController,
            label: 'Kód od instruktora',
            hint: 'Zadejte přístupový kód',
            icon: Icons.vpn_key_outlined,
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (_) => _redeemCode(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _redeemCode,
              icon: const Icon(Icons.lock_open_outlined),
              label: const Text('Ověřit kód a odemknout'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return _buildSectionCard(
      icon: Icons.train_outlined,
      color: Colors.blueGrey.shade700,
      title: 'Vaše aktuální oprávnění',
      subtitle: _unlockedVehicles.isEmpty ? 'Zatím nemáte odemčena žádná oprávnění.' : '${_unlockedVehicles.length} odemčených oprávnění',
      child: _buildVehiclesList(),
    );
  }

  Widget _buildDangerZone() {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.18)),
        boxShadow: dark ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.10), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.red),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nebezpečná zóna', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('Akce, které mohou smazat data.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Material(
            color: Colors.red.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: _deleteLocalData,
              borderRadius: BorderRadius.circular(14),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.delete_forever_outlined, color: Colors.red),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vymazat lokální data', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                          SizedBox(height: 3),
                          Text('Smaže jméno, licenci, DB URL a všechna oprávnění.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.red),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1976D2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.22), blurRadius: 18, offset: const Offset(0, 7))],
      ),
      child: Row(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nastavení aplikace', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('Správa průkazu, oprávnění a chování aplikace.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required IconData icon, required Color color, required String title, String? subtitle, required Widget child}) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: dark ? null : [BoxShadow(color: Colors.black.withOpacity(0.045), blurRadius: 13, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(13)),
                child: Icon(icon, color: color, size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required String hint, required IconData icon, TextInputAction? textInputAction, TextCapitalization textCapitalization = TextCapitalization.none, ValueChanged<String>? onSubmitted}) {
    return TextField(
      controller: controller, textInputAction: textInputAction, textCapitalization: textCapitalization, onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label, hintText: hint, prefixIcon: Icon(icon), filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.15))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
      ),
    );
  }

  Widget _buildDropdown({required String value, required String label, required IconData icon, required List<DropdownMenuItem<String>> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: items.map((e) => e.value).contains(value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon), filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.15))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildVehiclesList() {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    if (_unlockedVehicles.isEmpty) {
      return Container(
        width: double.infinity, padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey.shade500), const SizedBox(width: 12),
            Expanded(child: Text('Zatím nemáte odemčeno žádné vozidlo.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13))),
          ],
        ),
      );
    }
    return Column(
      children: _unlockedVehicles.map((vKey) {
        final bool isPerk = vKey == 'PERK_CREATOR';
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isPerk ? Colors.amber.withOpacity(dark ? 0.14 : 0.08) : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
            border: isPerk ? Border.all(color: Colors.amber.withOpacity(0.30)) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: isPerk ? Colors.amber.withOpacity(0.16) : Colors.green.withOpacity(0.10), borderRadius: BorderRadius.circular(11)),
                child: Icon(isPerk ? Icons.workspace_premium : Icons.check_circle_outline, color: isPerk ? Colors.amber.shade800 : Colors.green.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(_availableVehicles[vKey] ?? vKey, style: TextStyle(fontWeight: isPerk ? FontWeight.w800 : FontWeight.w600, fontSize: 14))),
              Icon(Icons.verified, size: 18, color: isPerk ? Colors.amber.shade800 : Colors.green.shade700),
            ],
          ),
        );
      }).toList(),
    );
  }
}