import 'package:flutter/material.dart';
import 'package:myapp/providers/quest_provider.dart';
import 'package:provider/provider.dart';

class AddPointScreen extends StatefulWidget {
  const AddPointScreen({super.key});

  @override
  State<AddPointScreen> createState() => _AddPointScreenState();
}

class _AddPointScreenState extends State<AddPointScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController progressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    progressController.dispose();
    super.dispose();
  }

  void _saveQuest() {
    if (nameController.text.isEmpty ||
        double.tryParse(progressController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid data')),
      );
      return;
    }

    final name = nameController.text;
    final progress = double.parse(progressController.text);

    Provider.of<QuestProvider>(context, listen: false).addQuest(name, progress);

    Navigator.pop(context); // Kembali ke layar sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Quest Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: progressController,
              decoration: const InputDecoration(labelText: 'Progress (%)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveQuest,
              child: const Text('Save Quest'),
            ),
          ],
        ),
      ),
    );
  }
}
