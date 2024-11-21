import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hura_point_provider.dart';

class HuraPointScreen extends StatelessWidget {
  const HuraPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final huraProvider = Provider.of<HuraPointProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Total Points Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: colorScheme.primary, size: 32),
                      SizedBox(width: 10),
                      Text(
                        "Total Points: ${huraProvider.huraPoint.totalPoints}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Daily Progress Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Progress",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground),
                      ),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: huraProvider.huraPoint.currentPoints /
                              huraProvider.huraPoint.dailyLimit,
                          minHeight: 10,
                          backgroundColor: colorScheme.surface,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${huraProvider.huraPoint.currentPoints}/${huraProvider.huraPoint.dailyLimit} Points",
                        style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onBackground.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: huraProvider.huraPoint.canClaim()
                          ? () {
                              huraProvider.addDailyPoints(1);
                            }
                          : null,
                      icon: Icon(Icons.add_circle_outline),
                      label: Text("Add Daily Point"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        huraProvider.claimPoints(5);
                      },
                      icon: Icon(Icons.military_tech_outlined),
                      label: Text("Claim Mission"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
