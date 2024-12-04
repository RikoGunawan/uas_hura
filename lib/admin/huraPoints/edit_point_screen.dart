import 'package:flutter/material.dart';
import 'package:myapp/models/quest.dart';

class EditHuraQuest extends StatefulWidget {
  final List<Quest> quests;

  const EditHuraQuest({super.key, required this.quests});

  @override
  State<EditHuraQuest> createState() => _EditHuraQuestState();
}

class _EditHuraQuestState extends State<EditHuraQuest> {
  void _editQuest(Quest quest) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
            TextEditingController(text: quest.name);
        final TextEditingController progressController =
            TextEditingController(text: quest.progress.toString());

        return AlertDialog(
          title: const Text('Edit Quest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Quest Name'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: progressController,
                decoration: const InputDecoration(labelText: 'Progress'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  quest.name = nameController.text;
                  quest.progress = double.tryParse(progressController.text) ?? quest.progress;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
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
      body: ListView.builder(
        itemCount: widget.quests.length,
        itemBuilder: (context, index) {
          final quest = widget.quests[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  quest.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress: ${(quest.progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: quest.progress,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editQuest(quest),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
