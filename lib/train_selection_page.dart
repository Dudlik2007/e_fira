import 'package:flutter/material.dart';
import 'report_page.dart';
import 'report_data.dart';

class TrainSelectionPage extends StatelessWidget {
  const TrainSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ReportData> trains = [
      ReportData(
        trainName: "R123",
        trainNumber: "123",
        maxSpeed: "160",
        trainLength: "250",
        trainWheels: "24n",
        trainCars: 8,
        brakeTypeD: "2",
        brakeTypeK: "4",
        brakeMode: "R+Mg",
        brakingModeP: "1",
        brakingModeR: "1",
        brakingModeRMg: "3",
        brakePercent: "85",
        brakingPercentageActual: "85",
        brakingPercentageRequired: "90",
        brakingPercentageMissing: "5",
        activeVehiclesCount: 5,
        transportVehiclesCount: 3,
        totalVehiclesCount: 7,
        activeVehiclesWeight: 300.0,
        transportVehiclesWeight: 120.0,
        totalVehiclesWeight: 420.0,
        departureStation: "Praha hl.n.",
        currentStation: "Kolín",
        destinationStation: "Brno hl.n.",
        uzbLocation: "Praha",
        uzbPerformedBy: "Strojvůdce",
        jzbLocation: "",
        jzbPerformedBy: "",
        nbuStatus: "NBÜ",
        topSpeedAllowed: "160",
        doorControlStatus: "---",
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
