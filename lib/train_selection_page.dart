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
      //  doorSystem: "Elektronický",
      //  power25kV: "Zapnuto",
        topSpeedAllowed: "160",
        doorControlStatus: "---",
        powerSupplyStatus: "---",
        highSpeedCarsStatus: "ANO",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Výběr vlaku",
        style: TextStyle(color: Color(0xffffffff)),)
      ),
      body: ListView.builder(
        itemCount: trains.length,
        itemBuilder: (context, index) {
          final train = trains[index];
          return ListTile(
            title: Text("${train.trainName} (${train.trainNumber})"),
            subtitle: Text("Rychlost: ${train.maxSpeed} km/h"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportPage(data: train),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
