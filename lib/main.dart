import 'package:flutter/material.dart';
import 'train_selection_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zpráva o brzdění',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TrainSelectionPage(), // první obrazovka = výběr vlaku
    );
  }
}
