import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'train_selection_page.dart';

// --- Začátek aplikace ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final skipWelcome = prefs.getBool('skipWelcome') ?? false;

  runApp(MyApp(skipWelcome: skipWelcome));
}

class MyApp extends StatelessWidget {
  final bool skipWelcome;
  const MyApp({super.key, required this.skipWelcome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zpráva o brzdění',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: skipWelcome
          ? const TrainSelectionPage()
          : const WelcomeScreen(), // první obrazovka
    );
  }
}

// --- Úvodní obrazovka ---
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.train, color: Colors.white, size: 100),
            const SizedBox(height: 30),
            const Text(
              'Vítejte v aplikaci\nZpráva o brzdění',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),

            // --- Tlačítka ---
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Pokračovat do aplikace'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrainSelectionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 15),

            ElevatedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text('Informace o aplikaci'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('O aplikaci'),
                    content: const Text(
                        'Tato aplikace slouží pro vytváření a správu zpráv o brzdění vlaků.\n'
                            'Podporuje načítání brzděnek z CSV souborů a dat pro eBulu z TXT souborů.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Zavřít'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 15),

            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Centrální nastavení'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('skipWelcome', true);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Uvítací obrazovka bude přeskočena při příštím spuštění.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
