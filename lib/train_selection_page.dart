import 'package:flutter/material.dart';
import 'report_page.dart';
import 'report_data.dart';

class TrainSelectionPage extends StatelessWidget {
  const TrainSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ReportData> trains = [
      ReportData(
        trainName: "Os10542",
        trainNumber: "10542",
        maxSpeed: "80",
        trainLength: "53",
        trainWheels: "12n",
        trainCars: 3,
        brakeTypeD: "0",
        brakeTypeK: "0",
        brakeMode: "P",
        brakingModeP: "3",
        brakingModeR: "0",
        brakingModeRMg: "0",
        brakePercent: "90",
        brakingPercentageActual: "90",
        brakingPercentageRequired: "90",
        brakingPercentageMissing: "0",
        activeVehiclesCount: 1,
        transportVehiclesCount: 2,
        totalVehiclesCount: 3,
        activeVehiclesWeight: 71.0,
        transportVehiclesWeight: 68.0,
        totalVehiclesWeight: 139.0,
        departureStation: "Albrechtice nad Vltavou",
        currentStation: "Albrechtice nad Vltavou",
        destinationStation: "Štěchovice",
        uzbLocation: "Albrechtice nad Vltavou",
        uzbPerformedBy: "Vozmistr",
        jzbLocation: "",
        jzbPerformedBy: "",
        nbuStatus: "NBÜ",
        topSpeedAllowed: "80",
        doorControlStatus: "TB 0",
        powerSupplyStatus: "---",
        highSpeedCarsStatus: "ANO",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // tmavé pozadí
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // tmavý appbar
        title: const Text(
          "Výběr vlaku",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: trains.length,
        itemBuilder: (context, index) {
          final train = trains[index];
          return Card(
            color: const Color(0xFF1E1E1E), // tmavé pozadí dlaždic
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(
                "${train.trainName} (${train.trainNumber})",
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Rychlost: ${train.maxSpeed} km/h",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportPage(data: train),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
