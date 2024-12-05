import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/utils/app_colors.dart';
import 'package:myapp/widgets/main_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/post.dart';
import '../../models/profile.dart';
import '../../providers/hura_point_provider.dart';
import '../../services/post_service.dart';

class AddPostScreenOnline extends StatefulWidget {
  const AddPostScreenOnline({super.key});

  @override
  State<AddPostScreenOnline> createState() => _AddPostScreenOnlineState();
}

class _AddPostScreenOnlineState extends State<AddPostScreenOnline> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImageFile;
  Uint8List? _selectedImageWeb;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedImageWeb = result.files.single.bytes;
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _createPost() async {
    if (_selectedImageFile == null && _selectedImageWeb == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }

    final profileResponse = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    final userProfile = Profile.fromJson(profileResponse);

    final post = Post(
      id: Uuid().v4(),
      name: _nameController.text,
      description: _descriptionController.text,
      imageUrl: '',
      likes: 0,
      shares: 0,
      userId: user.id,
      userImageUrl: userProfile.imageurl,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading...')),
    );

    if (kIsWeb && _selectedImageWeb != null) {
      await uploadAndCreatePostWeb(_selectedImageWeb!, post);
    } else if (_selectedImageFile != null) {
      await uploadAndCreatePost(_selectedImageFile!, post);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created successfully!')),
    );

    _resetForm();

    final huraPointProvider =
        Provider.of<HuraPointProvider>(context, listen: false);
    huraPointProvider.addDailyPoints(2);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainWidget()),
    );
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImageFile = null;
      _selectedImageWeb = null;
    });
  }

  Widget buildImagePreview() {
    if (_selectedImageWeb != null) {
      return Image.memory(
        _selectedImageWeb!,
        fit: BoxFit.contain,
      );
    } else if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        fit: BoxFit.contain,
      );
    } else {
      return Container(
        height: 200,
        alignment: Alignment.center,
        color: Colors.grey[300],
        child: const Text(
          'No image selected',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: buildImagePreview(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text(
                'Pick Image',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white, // White text for better contrast
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _createPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
