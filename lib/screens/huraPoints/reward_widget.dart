import 'package:flutter/material.dart';
import 'package:myapp/providers/hura_point_provider.dart';
import 'package:provider/provider.dart'; // Make sure to add provider to your dependencies

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HuraPointProvider(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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

Widget buildContainerReward(BuildContext context, String type, double progress,
    int totalPoints, int currentPoints) {
  final List<Map<String, String>> rewardList = [
    {'points': '50', 'reward': '1 Tiket Gratis'},
    {'points': '100', 'reward': 'Free Welcome Snack & Drink'},
    {'points': '200', 'reward': '1 Free Merchandise'},
    {'points': '500', 'reward': 'Voucher Makan Gratis Rp 50.000'},
    {'points': '1000', 'reward': '2 Voucher Hotel Gratis'},
  ];

  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.85,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: rewardList.length,
              itemBuilder: (context, index) {
                final reward = rewardList[index];
                bool isClaimed = currentPoints >= int.parse(reward['points']!);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${reward['points']} poin',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              reward['reward']!,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
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
