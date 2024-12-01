import 'package:flutter/material.dart';
import 'package:myapp/providers/hura_point_provider.dart';
import 'package:provider/provider.dart'; // Make sure to add provider to your dependencies
import 'package:shared_preferences/shared_preferences.dart';

class RewardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HuraPointProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rewards"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Available Rewards',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Consumer<HuraPointProvider>(
                builder: (context, provider, child) {
                  return buildContainerReward(
                    context,
                    'Reward',
                    provider.progress,
                    provider.huraPoint.totalPoints,
                    provider.huraPoint.currentPoints,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modify the reward widget to use data from the provider
Widget buildContainerReward(BuildContext context, String type, double progress,
    int totalPoints, int currentPoints) {
  // Define the reward data
  final List<Map<String, String>> rewardList = [
    {'points': '50', 'reward': 'Tiket gratis'},
    {'points': '100', 'reward': 'Paket Sponsor 1'},
    // Add more rewards here as needed
  ];

  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5, // Max height 50%
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true, // Adjust height based on content
              physics: const ClampingScrollPhysics(),
              itemCount: rewardList.length,
              itemBuilder: (context, index) {
                final reward = rewardList[index];
                bool isClaimed = currentPoints >=
                    int.parse(reward[
                        'points']!); // Check if points are enough for claim

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12.0,
                        backgroundColor: isClaimed ? Colors.green : Colors.grey,
                        child: Icon(
                          isClaimed ? Icons.check : Icons.lock,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        '${reward['points']} poin => ${reward['reward']}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
