import 'package:flutter/material.dart';
import 'package:myapp/models/quest.dart';
import 'package:myapp/providers/quest_provider.dart';
import 'package:provider/provider.dart';

class EditPointScreen extends StatelessWidget {
  const EditPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure quests are loaded
    final questProvider = Provider.of<QuestProvider>(context);
    questProvider.getQuests();  // Ensure we get quests if not already loaded

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
                subtitle: Text('Progress: ${quest.progress.toStringAsFixed(1)}%'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _openEditDialog(context, quest, questProvider);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        questProvider.removeQuest(quest.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddDialog(context, context.read<QuestProvider>());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openEditDialog(BuildContext context, Quest quest, QuestProvider questProvider) {
    final TextEditingController questNameController = TextEditingController(text: quest.name);
    double progress = quest.progress;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Quest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questNameController,
                decoration: const InputDecoration(labelText: 'Quest Name'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Progress'),
                onChanged: (value) {
                  progress = double.tryParse(value) ?? progress; // Keep old progress if invalid input
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
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

  void _openAddDialog(BuildContext context, QuestProvider questProvider) {
    final TextEditingController questNameController = TextEditingController();
    double progress = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Quest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questNameController,
                decoration: const InputDecoration(labelText: 'Quest Name'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Progress'),
                onChanged: (value) {
                  progress = double.tryParse(value) ?? progress; // Handle invalid input
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                questProvider.addQuest(
                  questNameController.text,
                  progress,
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
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
}
