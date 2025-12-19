import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Vrátí cestu ke složce TJR podle platformy.
/// Automaticky vytvoří složky, pokud neexistují.
Future<Directory> getTjrDirectory() async {
  Directory baseDir;

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final docs = await getApplicationDocumentsDirectory();
    baseDir = Directory('${docs.path}/Brzdenka/TJR');
  } else {
    // Android + iOS: použije interní dokumenty aplikace
    final appDocs = await getApplicationDocumentsDirectory();
    baseDir = Directory('${appDocs.path}/TJR');
  }

  if (!await baseDir.exists()) {
    await baseDir.create(recursive: true);
  }
  return baseDir;
}
