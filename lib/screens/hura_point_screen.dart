import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hura_point_provider.dart';

class HuraPointScreen extends StatelessWidget {
  const HuraPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final huraProvider = Provider.of<HuraPointProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Hura Point")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: huraProvider.huraPoint.currentPoints /
                  huraProvider.huraPoint.dailyLimit,
              minHeight: 10,
            ),
            SizedBox(height: 8),
            Text(
              "${huraProvider.huraPoint.currentPoints}/${huraProvider.huraPoint.dailyLimit}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: huraProvider.huraPoint.canClaim()
                  ? () {
                      huraProvider.addDailyPoints(1);
                    }
                  : null, // Disabled jika sudah penuh
              child: Text("Add Daily Point"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                huraProvider.claimPoints(5); // Tambahkan 5 poin saat klaim
              },
              child: Text("Claim Mission Points"),
            ),
            SizedBox(height: 20),
            Text(
              "Total Points: ${huraProvider.huraPoint.totalPoints}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
