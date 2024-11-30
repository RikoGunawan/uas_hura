import 'package:flutter/material.dart';
import 'package:myapp/models/quest.dart';
import 'package:myapp/providers/quest_provider.dart';
import 'package:provider/provider.dart';

class EditPointScreen extends StatelessWidget {
  const EditPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quests'),
      ),
      body: Consumer<QuestProvider>(
        builder: (context, questProvider, child) {
          final quests = questProvider.quests;

          return ListView.builder(
            itemCount: quests.length,
            itemBuilder: (context, index) {
              final quest = quests[index];

              return ListTile(
                title: Text(quest.name),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Open the edit dialog for each quest
                    _openEditDialog(context, quest, questProvider);
                  },
                ),
              );
            },
          );
        },
      ),
      // Floating action button to add a new quest
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddDialog(context, context.read<QuestProvider>());
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Method to open the edit dialog for a specific quest
  void _openEditDialog(
      BuildContext context, Quest quest, QuestProvider questProvider) {
    final TextEditingController questNameController =
        TextEditingController(text: quest.name);
    double progress = quest.progress;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Quest'),
          content: Column(
            children: [
              TextField(
                controller: questNameController,
                decoration: const InputDecoration(labelText: 'Quest Name'),
              ),
              TextField(
                controller: TextEditingController(text: progress.toString()),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Progress'),
                onChanged: (value) {
                  progress = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save the updated quest
                questProvider.updateQuest(
                  quest.id,
                  questNameController.text,
                  progress,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to open the add new quest dialog
  void _openAddDialog(BuildContext context, QuestProvider questProvider) {
    final TextEditingController questNameController = TextEditingController();
    double progress = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Quest'),
          content: Column(
            children: [
              TextField(
                controller: questNameController,
                decoration: const InputDecoration(labelText: 'Quest Name'),
              ),
              TextField(
                controller: TextEditingController(text: progress.toString()),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Progress'),
                onChanged: (value) {
                  progress = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
