import 'app_database.dart';

// Globální instance databáze
late AppDatabase db;

Future<void> initDatabase() async {
  db = AppDatabase();
}