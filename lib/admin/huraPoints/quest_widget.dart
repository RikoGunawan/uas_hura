import 'package:flutter/material.dart';
import 'package:myapp/models/quest.dart';

Widget buildContainerQuest(BuildContext context, String type, List<Quest> quests) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5, // Max height 50% of screen height
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Hura Point',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: quests.length,
              itemBuilder: (context, index) {
                final quest = quests[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          style: const TextStyle(fontSize: 12),
                          'Quest ${quest.id}: ${quest.name}', // Display quest ID and name
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0), // Gap between quests
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
