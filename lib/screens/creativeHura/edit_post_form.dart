import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../services/post_service.dart';

class EditPostForm extends StatefulWidget {
  final Post post;

  const EditPostForm({super.key, required this.post});

  @override
  State<EditPostForm> createState() => _EditPostFormState();
}

class _EditPostFormState extends State<EditPostForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePostData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializePostData() {
    // Mengisi controller dengan data dari post yang diterima
    _titleController.text = widget.post.name;
    _descriptionController.text = widget.post.description;
  }

  Future<void> _savePost() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    try {
      // Panggil fungsi updatePost dengan ID post dan data baru
      await updatePost(widget.post.id, title, description);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully')),
      );
      Navigator.pop(context, true); // Mengembalikan hasil ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePost,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
