import 'package:flutter/material.dart';
import 'package:myapp/providers/quest_provider.dart';
import 'package:provider/provider.dart';

Widget buildContainerQuest(BuildContext context) {
  return Consumer<QuestProvider>(
    builder: (context, questProvider, child) {
      final quests = questProvider.quests;

      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.85, // 85% dari lebar layar
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height *
              0.5, // Maksimal 50% tinggi layar
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quest', // Judul kontainer
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: quests.isEmpty
                  ? const Center(child: Text('No quests available'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: quests.length,
                      itemBuilder: (context, index) {
                        final quest = quests[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 12.0,
                                    backgroundColor: Colors.white,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    quest.name,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              LinearProgressIndicator(
                                value: quest.progress / 100.0,
                                backgroundColor: Colors.grey[400],
                                color: Colors.blue,
                                minHeight: 5.0,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}
