import 'package:flutter/material.dart';

Widget buildContainerReward(
    BuildContext context, String type, double progress) {
  // Define the reward data
  final List<Map<String, String>> rewardList = [
    {'points': '50', 'reward': 'Tiket gratis'},
    {'points': '100', 'reward': 'Paket Sponsor 1'},
    // Add more rewards here as needed
  ];

  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Lighter background color
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
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
                bool isClaimed = index % 2 == 0; // Simulate claim status (for illustration)

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12.0,
                        backgroundColor:
                            isClaimed ? Colors.green : Colors.grey,
                        child: Icon(
                          isClaimed ? Icons.check : Icons.lock,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.white, // Progress line background
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                            ),
                            Container(
                              height: 10.0,
                              width: MediaQuery.of(context).size.width *
                                  0.8 *
                                  progress, // Adjusted progress bar
                              decoration: BoxDecoration(
                                color: Colors.blue, // Progress bar color
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        '${reward['points']} poin = ${reward['reward']}',
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
