import 'package:flutter/material.dart';

// Model untuk Quest
class Quest {
  final int id;
  String name;

  Quest({required this.id, required this.name});
}

class EditPointScreen extends StatefulWidget {
  const EditPointScreen({super.key});

  @override
  State<EditPointScreen> createState() => _EditPointScreenState();
}

class _EditPointScreenState extends State<EditPointScreen> {
  final List<Quest> quests = [
    Quest(id: 1, name: 'Quest 1'),
    Quest(id: 2, name: 'Quest 2'),
    Quest(id: 3, name: 'Quest 3'),
  ];

  final TextEditingController questNameController = TextEditingController();

  @override
  void dispose() {
    questNameController.dispose();
    super.dispose();
  }

  void _showQuestDialog(Quest quest) {
    questNameController.text = quest.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Quest'),
          content: TextField(
            controller: questNameController,
            decoration: const InputDecoration(labelText: 'Quest Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  quest.name = questNameController.text;
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quests'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quests.length,
              itemBuilder: (context, index) {
                final quest = quests[index];
                return ListTile(
                  title: Text(quest.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showQuestDialog(quest),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
