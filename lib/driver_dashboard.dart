import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

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
  // NASTAVENÍ ZOBRAZENÍ A FILTRŮ (z SharedPreferences)
  // ============================================================
  String _displayMode = 'name'; 
  
  String _leaderboardFilter = 'all'; // 'all', 'range', 'specific'
  String _filterRangeFrom = '';
  String _filterRangeTo = '';
  List<String> _filterSpecific = [];

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

  List<String> get _vehicleOptions {
    if (_isTraining) return _availableVehicles.keys.toList();
    return _myVehicles;
  }

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
  // NAČTENÍ OPRÁVNĚNÍ A NASTAVENÍ
  // ============================================================
  Future<void> _loadPermissions() async {
    final prefs = await SharedPreferences.getInstance();

    final unlocked = prefs.getStringList('unlockedVehicles') ?? [];
    _savedName = prefs.getString('driverName') ?? '';
    _savedLicense = prefs.getString('licenseNumber') ?? '';
    
    // Zobrazení a Filtry
    _displayMode = prefs.getString('leaderboard_display_mode') ?? 'name';
    _leaderboardFilter = prefs.getString('leaderboardFilter') ?? 'all';
    _filterRangeFrom = prefs.getString('filterRangeFrom') ?? '';
    _filterRangeTo = prefs.getString('filterRangeTo') ?? '';
    _filterSpecific = prefs.getStringList('filterSpecific') ?? [];

    final myVehicles = unlocked
        .where((v) => v != 'D1_ZPUSOBILOST' && v != 'PERK_CREATOR')
        .where((v) => _availableVehicles.containsKey(v))
        .toList();

    if (!mounted) return;

    setState(() {
      _nameController.text = _savedName;
      _licenseController.text = _savedLicense;

      _hasD1 = unlocked.contains('D1_ZPUSOBILOST');
      _hasCreatorPerk = unlocked.contains('PERK_CREATOR');
      _myVehicles = myVehicles;

      if (_myVehicles.isNotEmpty) {
        _selectedVehicle = _myVehicles.first;
      }
      _isLoading = false;
    });
  }

  // ============================================================
  // PŘIDÁNÍ KILOMETRŮ
  // ============================================================
  Future<void> _addKilometers() async {
    final String typedName = _nameController.text.trim();
    final String typedLicense = _licenseController.text.trim();
    final double? inputVal = double.tryParse(
      _kmController.text.trim().replaceAll(',', '.'),
    );

    if (typedName.isEmpty || typedLicense.isEmpty || inputVal == null || inputVal <= 0 || _selectedVehicle == null) {
      _showMessage('Vyplňte všechny údaje správně.', color: Colors.red);
      return;
    }

    if (!_hasCreatorPerk && (typedName != _savedName || typedLicense != _savedLicense)) {
      _showMessage('Nemáte oprávnění zapisovat výkon za jiné osoby.', color: Colors.red);
      return;
    }

    if (!_isTraining && !_myVehicles.contains(_selectedVehicle)) {
      _showMessage('Tento stroj nemáte ve svých oprávněních.', color: Colors.red);
      return;
    }

    final double kmToAdd = _selectedUnit == 'm' ? inputVal / 1000.0 : inputVal;
    final driverKey = typedLicense.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

    try {
      final String vehicleName = _availableVehicles[_selectedVehicle!] ?? _selectedVehicle!;
      final Map<String, dynamic> dataToUpdate = {
        'name': typedName,
        'license': typedLicense,
        'last_updated': FieldValue.serverTimestamp(),
        'last_vehicle': vehicleName,
        'total_km': FieldValue.increment(kmToAdd),
      };

      if (_isTraining) {
        dataToUpdate['training_km'] = FieldValue.increment(kmToAdd);
      }

      await _db.collection('drivers').doc(driverKey).set(dataToUpdate, SetOptions(merge: true));

      final double writtenKm = kmToAdd;

      setState(() {
        _isTraining = false;
        _kmController.clear();
        if (_myVehicles.isNotEmpty && !_myVehicles.contains(_selectedVehicle)) {
          _selectedVehicle = _myVehicles.first;
        }
      });

      if (!mounted) return;
      _showMessage(
        'Zapsáno ${_formatNumber(inputVal)} $_selectedUnit na stroji $vehicleName (${_formatNumber(writtenKm)} km).',
        color: Colors.green.shade700,
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('Chyba při zápisu: $e', color: Colors.red);
    }
  }

  // ============================================================
  // POMOCNÉ FUNKCE
  // ============================================================
  String _formatNumber(double number) {
    if (number == number.roundToDouble()) return number.toInt().toString();
    return number.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  void _showMessage(String message, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _setTraining(bool value) {
    setState(() {
      _isTraining = value;
      if (_isTraining) {
        if (!_vehicleOptions.contains(_selectedVehicle)) {
          _selectedVehicle = _vehicleOptions.isNotEmpty ? _vehicleOptions.first : null;
        }
      } else {
        if (!_myVehicles.contains(_selectedVehicle)) {
          _selectedVehicle = _myVehicles.isNotEmpty ? _myVehicles.first : null;
        }
      }
    });
  }

  // ============================================================
  // BUILD & SCROLLVIEW
  // ============================================================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text(
              'Žebříček a zápis km',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: isDark ? const Color(0xFF8D4F00) : Colors.orangeAccent,
            foregroundColor: Colors.white,
            pinned: true,
            elevation: 0,
          ),
          SliverToBoxAdapter(
            child: !_hasD1 ? _buildLockedCard(context) : _buildEntryCard(context, colors),
          ),
          SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 1, color: colors.outlineVariant),
          ),
          _buildLeaderboardSliver(context, colors),
        ],
      ),
    );
  }

  Widget _buildLockedCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      color: Colors.red.withOpacity(0.08),
      child: Column(
        children: [
          Container(
            width: 58, height: 58,
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.lock_outline, color: Colors.red, size: 30),
          ),
          const SizedBox(height: 12),
          const Text('Zápis výkonu je zablokován', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.red, fontSize: 18)),
          const SizedBox(height: 6),
          Text('Pro zápis kilometrů musíte nejprve složit zkoušku a zadat kód pro Odbornou způsobilost SŽ D1.', textAlign: TextAlign.center, style: TextStyle(color: colors.onSurface, fontSize: 13)),
        ],
      ),
    );
  }

  // ============================================================
  // KARTA ZÁPISU
  // ============================================================
  Widget _buildEntryCard(BuildContext context, ColorScheme colors) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.12), borderRadius: BorderRadius.circular(13)),
                      child: const Icon(Icons.add_road, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Zápis výkonu', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                          SizedBox(height: 2),
                          Text('Přidejte ujetou vzdálenost do systému.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    if (_hasCreatorPerk)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.13), borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.admin_panel_settings, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text('ADMIN', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w800, fontSize: 10)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool compact = constraints.maxWidth < 540;
                    if (compact) {
                      return Column(
                        children: [
                          _buildTextField(controller: _nameController, label: 'Jméno', icon: Icons.person_outline, readOnly: !_hasCreatorPerk),
                          const SizedBox(height: 10),
                          _buildTextField(controller: _licenseController, label: 'Licence', icon: Icons.badge_outlined, readOnly: !_hasCreatorPerk),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _nameController, label: 'Jméno', icon: Icons.person_outline, readOnly: !_hasCreatorPerk)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField(controller: _licenseController, label: 'Licence', icon: Icons.badge_outlined, readOnly: !_hasCreatorPerk)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool compact = constraints.maxWidth < 460;
                    if (compact) {
                      return Column(
                        children: [
                          _buildDistanceField(),
                          const SizedBox(height: 10),
                          _buildUnitDropdown(),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(flex: 2, child: _buildDistanceField()),
                        const SizedBox(width: 10),
                        Expanded(child: _buildUnitDropdown()),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                
                _buildVehicleDropdown(),
                const SizedBox(height: 4),
                
                Container(
                  decoration: BoxDecoration(
                    color: _isTraining ? Colors.blue.withOpacity(isDark ? 0.14 : 0.07) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: CheckboxListTile(
                    title: const Text('Zácviková jízda', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(_isTraining ? 'Aktivní – lze zvolit libovolný stroj.' : 'Běžná jízda – pouze vlastní oprávnění.'),
                    value: _isTraining,
                    onChanged: (value) => _setTraining(value ?? false),
                    secondary: Icon(_isTraining ? Icons.school : Icons.school_outlined, color: _isTraining ? Colors.blue : colors.onSurfaceVariant),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 6),
                
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Zapsat hodnoty do systému'),
                    onPressed: _isTraining || _myVehicles.isNotEmpty ? _addKilometers : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool readOnly = false}) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: controller, readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon), filled: true,
        fillColor: readOnly ? colors.surfaceContainerHighest.withOpacity(0.65) : colors.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDistanceField() {
    return TextField(
      controller: _kmController, keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: 'Ujetá vzdálenost', prefixIcon: Icon(Icons.add_road), border: OutlineInputBorder(), filled: true),
    );
  }

  Widget _buildUnitDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Jednotka', prefixIcon: Icon(Icons.straighten), border: OutlineInputBorder(), filled: true),
      value: _selectedUnit,
      items: const [DropdownMenuItem(value: 'km', child: Text('Kilometry')), DropdownMenuItem(value: 'm', child: Text('Metry'))],
      onChanged: (value) {
        if (value != null) setState(() => _selectedUnit = value);
      },
    );
  }

  Widget _buildVehicleDropdown() {
    final bool hasVehicles = _vehicleOptions.isNotEmpty;
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: _isTraining ? 'Simulátor / stroj – zácvik' : 'Simulátor / stroj',
        helperText: _isTraining ? 'Při zácviku jsou dostupné všechny stroje.' : hasVehicles ? 'Zobrazují se pouze vaše oprávnění.' : 'Nemáte zatím žádné oprávnění.',
        prefixIcon: Icon(_isTraining ? Icons.school_outlined : Icons.train_outlined),
        border: const OutlineInputBorder(), filled: true,
      ),
      value: _vehicleOptions.contains(_selectedVehicle) ? _selectedVehicle : null,
      items: _vehicleOptions.map((v) => DropdownMenuItem<String>(value: v, child: Text(_availableVehicles[v] ?? v, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: hasVehicles ? (value) => setState(() => _selectedVehicle = value) : null,
      hint: const Text('Vyberte stroj'),
    );
  }

  // ============================================================
  // ŽEBŘÍČEK S APLIKOVANÝM FILTREM
  // ============================================================
  Widget _buildLeaderboardSliver(BuildContext context, ColorScheme colors) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('drivers').orderBy('total_km', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Chyba při načítání žebříčku:\n${snapshot.error}', textAlign: TextAlign.center),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SliverToBoxAdapter(child: _buildEmptyLeaderboard(isFiltered: false));
        }

        // 1. Získání všech dat ze snapshotu
        List<Map<String, dynamic>> drivers = snapshot.data!.docs
            .map((d) => d.data() as Map<String, dynamic>)
            .toList();

        // 2. Aplikace filtru na základě nastavení
        if (_leaderboardFilter == 'specific' && _filterSpecific.isNotEmpty) {
          drivers = drivers.where((d) {
            final lic = (d['license'] ?? '').toString();
            return _filterSpecific.contains(lic);
          }).toList();
        } 
        else if (_leaderboardFilter == 'range') {
          // Extrahuje pouze číslice ze stringů (např. z "MASNA-012" dostane "12")
          final int? fromNum = int.tryParse(_filterRangeFrom.replaceAll(RegExp(r'[^0-9]'), ''));
          final int? toNum = int.tryParse(_filterRangeTo.replaceAll(RegExp(r'[^0-9]'), ''));
          
          if (fromNum != null && toNum != null) {
            drivers = drivers.where((d) {
              final lic = (d['license'] ?? '').toString();
              final licNum = int.tryParse(lic.replaceAll(RegExp(r'[^0-9]'), ''));
              if (licNum == null) return false;
              
              return licNum >= fromNum && licNum <= toNum;
            }).toList();
          }
        }

        // Pokud filtr odfiltroval všechny průkazy
        if (drivers.isEmpty) {
          return SliverToBoxAdapter(child: _buildEmptyLeaderboard(isFiltered: true));
        }

        // Nastavení maxima ze seřazeného a vyfiltrovaného seznamu
        final double maxKm = _toDouble(drivers.first['total_km'] ?? 0);
        final double scaleMax = maxKm <= 0 ? 1 : maxKm;

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildDriverRow(context, drivers[index], index, scaleMax);
              },
              childCount: drivers.length,
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // JEDEN ŘÁDEK ŽEBŘÍČKU
  // ============================================================
  Widget _buildDriverRow(BuildContext context, Map<String, dynamic> data, int index, double scaleMax) {
    final colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final double totalKm = _toDouble(data['total_km'] ?? 0);
    final double trainingKm = _toDouble(data['training_km'] ?? 0);
    
    final String dataName = data['name'] ?? 'Neznámý';
    final String dataLicense = data['license'] ?? 'Neznámá licence';
    
    String displayName;
    switch (_displayMode) {
      case 'license':
        displayName = dataLicense;
        break;
      case 'both':
        displayName = '$dataName ($dataLicense)';
        break;
      case 'name':
      default:
        displayName = dataName;
        break;
    }

    final String lastVehicle = data['last_vehicle'] ?? 'Neznámo';
    final double fraction = (totalKm / scaleMax).clamp(0.0, 1.0);
    final bool isFirst = index == 0;

    final Color rankColor = index == 0 ? Colors.amber.shade700 : index == 1 ? Colors.grey.shade500 : index == 2 ? Colors.brown.shade400 : colors.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isFirst ? Colors.amber.withOpacity(0.30) : colors.outlineVariant.withOpacity(0.45)),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.035), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 38,
            child: Column(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: rankColor.withOpacity(0.12), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('${index + 1}', style: TextStyle(color: rankColor, fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(displayName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(lastVehicle, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double safeFraction = fraction.clamp(0.0, 1.0);
                    return Stack(
                      children: [
                        Container(
                          height: 28, width: double.infinity,
                          decoration: BoxDecoration(color: colors.surfaceContainerHighest, borderRadius: BorderRadius.circular(14)),
                        ),
                        FractionallySizedBox(
                          widthFactor: safeFraction,
                          child: Container(
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: isFirst ? [Colors.amber.shade400, Colors.orange.shade600] : [Colors.blue.shade300, Colors.blue.shade700]),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: trainingKm > 0
                                      ? Text('Zácvik: ${_formatNumber(trainingKm)} km', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: safeFraction > 0.35 ? Colors.white : colors.onSurfaceVariant))
                                      : const SizedBox(),
                                ),
                                const SizedBox(width: 8),
                                Text('${_formatNumber(totalKm)} km', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: safeFraction > 0.50 ? Colors.white : colors.onSurface)),
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

  // Přidán parametr pro rozpoznání, zda je žebříček prázdný databázově, nebo jen kvůli filtru
  Widget _buildEmptyLeaderboard({required bool isFiltered}) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(color: colors.surfaceContainerHighest, shape: BoxShape.circle),
              child: Icon(isFiltered ? Icons.filter_alt_off_outlined : Icons.emoji_events_outlined, size: 36, color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            Text(
              isFiltered ? 'Zvolenému filtru neodpovídá žádný strojvedoucí.' : 'Zatím nejsou zapsáni žádní strojvedoucí.', 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)
            ),
            const SizedBox(height: 5),
            Text(
              isFiltered ? 'Zkuste změnit nastavení filtru.' : 'Po prvním zápisu se zde zobrazí žebříček.', 
              textAlign: TextAlign.center, 
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12)
            ),
          ],
        ),
      ),
    );
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}