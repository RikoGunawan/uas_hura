import 'package:flutter/material.dart';

// Model untuk Quest
class Quest {
  final String name;
  final double progress;

  Quest({required this.name, required this.progress});
}

class AddPointScreen extends StatefulWidget {
  const AddPointScreen({super.key});

  @override
  State<AddPointScreen> createState() => _AddPointScreenState();
}

class _AddPointScreenState extends State<AddPointScreen> {
  // List untuk menyimpan data quest
  final List<Quest> quests = [];

  // Controller untuk input teks
  final TextEditingController nameController = TextEditingController();
  final TextEditingController progressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    progressController.dispose();
    super.dispose();
  }

  // Menampilkan dialog untuk menambah atau mengedit quest
  void _showQuestDialog({Quest? quest}) {
    if (quest != null) {
      // Jika mengedit, isi controller dengan data quest yang ada
      nameController.text = quest.name;
      progressController.text = quest.progress.toString();
    } else {
      // Jika menambah, kosongkan controller
      nameController.clear();
      progressController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(quest == null ? 'Add Quest' : 'Edit Quest'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Quest Name'),
                ),
                TextField(
                  controller: progressController,
                  decoration: const InputDecoration(labelText: 'Progress (%)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newQuest = Quest(
                  name: nameController.text,
                  progress: double.tryParse(progressController.text) ?? 0.0,
                );

                // Menambah atau mengedit quest
                if (quest == null) {
                  _addQuest(newQuest);
                } else {
                  _editQuest(quest, newQuest);
                }

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

  // Fungsi untuk menambah quest baru
  void _addQuest(Quest quest) {
    setState(() {
      quests.add(quest);
    });
  }

  // Fungsi untuk mengedit quest
  void _editQuest(Quest oldQuest, Quest updatedQuest) {
    setState(() {
      final index = quests.indexOf(oldQuest);
      if (index != -1) {
        quests[index] = updatedQuest;
      }
    });
  }

  // Fungsi untuk menghapus quest
  void _deleteQuest(Quest quest) {
    setState(() {
      quests.remove(quest);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quests'),
      ),
      body: Column(
        children: [
          // Daftar quest
          Expanded(
            child: ListView.builder(
              itemCount: quests.length,
              itemBuilder: (context, index) {
                final quest = quests[index];
                return ListTile(
                  leading: CircularProgressIndicator(
                    value: quest.progress / 100,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue,
                  ),
                  title: Text(quest.name),
                  subtitle:
                      Text('Progress: ${quest.progress.toStringAsFixed(1)}%'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showQuestDialog(quest: quest),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteQuest(quest),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Tombol untuk menambah quest baru
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _showQuestDialog(),
              child: const Text('Add Quest'),
            ),
          ),
        ],
      ),
    );
  }
}
