import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app_theme.dart';

import 'train_selection_page.dart';
import 'settings_screen.dart';
import 'driver_dashboard.dart';
import 'license_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();

  final skipWelcome = prefs.getBool('skipWelcome') ?? false;
  final darkMode = prefs.getBool('darkMode') ?? false;

  // Načtení uloženého režimu
  appDarkMode.value = darkMode;

  runApp(
    MyApp(
      skipWelcome: skipWelcome,
    ),
  );
}

// ============================================================
// HLAVNÍ APLIKACE
// ============================================================

class MyApp extends StatelessWidget {
  final bool skipWelcome;

  const MyApp({
    super.key,
    required this.skipWelcome,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: appDarkMode,

      builder: (context, darkMode, child) {
        return MaterialApp(
          title: 'Zpráva o brzdění',
          debugShowCheckedModeBanner: false,

          // ==================================================
          // SVĚTLÉ TÉMA
          // ==================================================

          theme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),

            scaffoldBackgroundColor:
                const Color(0xFFF4F7FB),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
            ),

            inputDecorationTheme:
                InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFFF7F9FC),

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(
                  Radius.circular(14),
                ),
                borderSide: BorderSide.none,
              ),
            ),

            cardTheme: const CardThemeData(
              color: Colors.white,
              elevation: 0,
            ),
          ),

          // ==================================================
          // TMAVÉ TÉMA
          // ==================================================

          darkTheme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),

            scaffoldBackgroundColor:
                const Color(0xFF101318),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0B2E59),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
            ),

            inputDecorationTheme:
                InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF1D232C),

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(
                  Radius.circular(14),
                ),
                borderSide: BorderSide.none,
              ),
            ),

            cardTheme: const CardThemeData(
              color: Color(0xFF1A1F26),
              elevation: 0,
            ),

            dividerTheme: DividerThemeData(
              color: Colors.white.withOpacity(0.10),
            ),
          ),

          themeMode:
              darkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,

          // ==================================================
          // START APLIKACE
          // ==================================================

          home: skipWelcome
              ? const TrainSelectionPage()
              : const WelcomeScreen(),
        );
      },
    );
  }
}

// ============================================================
// ÚVODNÍ OBRAZOVKA
// ============================================================

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Na PC a tabletech nebude menu zbytečně široké.
    final double maxWidth =
        size.width > 700 ? 560 : double.infinity;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ==================================================
                    // HLAVIČKA
                    // ==================================================

                    _buildHeader(),

                    const SizedBox(height: 28),

                    // ==================================================
                    // HLAVNÍ MENU
                    // ==================================================

                    Container(
                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        // V tmavém režimu trochu tmavší
                        // transparentní karta.
                        color:
                            Theme.of(context)
                                    .brightness ==
                                Brightness.dark
                            ? const Color(0xFF171C23)
                                .withOpacity(0.96)
                            : Colors.white
                                .withOpacity(0.97),

                        borderRadius:
                            BorderRadius.circular(24),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.18),
                            blurRadius: 25,
                            offset:
                                const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [

                          // ==================================================
                          // TVORBA ZPRÁVY
                          // ==================================================

                          _MenuButton(
                            icon:
                                Icons.train_outlined,
                            title:
                                'Zprávy o brzdění a TJŘ',
                            subtitle:
                                'Otevřít bržděnku/TJŘ pro vybraný vlak',
                            color:
                                const Color(0xFF1565C0),

                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const TrainSelectionPage(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // ==================================================
                          // ZÁPISY
                          // ==================================================

                          _MenuButton(
                            icon: Icons
                                .workspace_premium_outlined,
                            title:
                                'Zápisy o ujetých kilometrech',
                            subtitle:
                                'Statistiky a žebříček strojvedoucích',
                            color:
                                const Color(0xFFE65100),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const DriverDashboardScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // ==================================================
                          // PRŮKAZ
                          // ==================================================

                          _MenuButton(
                            icon:
                                Icons.badge_outlined,
                            title:
                                'Má licence strojvedoucího',
                            subtitle:
                                'Zobrazit moji digitální licenci',
                            color:
                                const Color(0xFF1B1B3A),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LicenseScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // ==================================================
                          // INFORMACE
                          // ==================================================

                          _MenuButton(
                            icon:
                                Icons.info_outline,
                            title:
                                'Informace o aplikaci',
                            subtitle:
                                'Verze, funkce a informace',
                            color:
                                const Color(0xFF455A64),

                            onTap: () {
                              _showInfoDialog(context);
                            },
                          ),

                          const SizedBox(height: 12),

                          // ==================================================
                          // NASTAVENÍ
                          // ==================================================

                          _MenuButton(
                            icon:
                                Icons.settings_outlined,
                            title:
                                'Centrální nastavení',
                            subtitle:
                                'Nastavení aplikace a dat',
                            color:
                                const Color(0xFF37474F),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // PATIČKA
                    // ==================================================

                    Text(
                      'Zpráva o brzdění',
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(0.85),
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Digitální nástroj pro strojvedoucí',
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(0.65),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HLAVIČKA
  // ============================================================

Widget _buildHeader() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 130,
        height: 130,
        child: Image.asset(
          'assets/icon/logo.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),

      const SizedBox(height: 12),

      const Text(
        'E-Fíra',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),

      const SizedBox(height: 6),

      Text(
        'Digitální aplikace pro strojvedoucí',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 14,
        ),
      ),
    ],
  );
}

  // ============================================================
  // INFO DIALOG
  // ============================================================

  void _showInfoDialog(
      BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.train,
                color:
                    Color(0xFF1565C0),
              ),

              SizedBox(width: 10),

              Text('O aplikaci'),
            ],
          ),

          content: const Text(
            'Tato aplikace slouží pro '
            'vytváření a správu zpráv '
            'o brzdění vlaků.\n\n'
            'Podporuje načítání brzděnek '
            'z CSV souborů a dat pro '
            'eBulu z TXT souborů.\n\n'
            'Součástí aplikace je také '
            'modul pro sledování licencí '
            'strojvedoucích, ujetých '
            'kilometrů a žebříčku '
            'strojvedoucích.',
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),

              child:
                  const Text('Zavřít'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// TLAČÍTKO MENU
// ============================================================

class _MenuButton
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(17),

        child: Ink(
          width: double.infinity,

          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),

          decoration: BoxDecoration(
            color: dark
                ? color.withOpacity(0.14)
                : color.withOpacity(0.07),

            borderRadius:
                BorderRadius.circular(17),

            border: Border.all(
              color:
                  color.withOpacity(0.18),
            ),
          ),

          child: Row(
            children: [

              // ==================================================
              // IKONA
              // ==================================================

              Container(
                width: 48,
                height: 48,

                decoration:
                    BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              // ==================================================
              // TEXT
              // ==================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        color: dark
                            ? Colors.white
                            : color,

                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        color: dark
                            ? Colors.white70
                            : Colors.grey.shade600,

                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ==================================================
              // ŠIPKA
              // ==================================================

              Icon(
                Icons.chevron_right,
                color:
                    dark
                        ? Colors.white70
                        : color.withOpacity(0.7),
                size: 27,
              ),
            ],
          ),
        ),
      ),
    );
  }
}