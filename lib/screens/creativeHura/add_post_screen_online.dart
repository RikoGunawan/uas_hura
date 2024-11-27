import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:file_picker/file_picker.dart'; // Untuk Web
import 'package:image_picker/image_picker.dart'; // Untuk Mobile
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/post2.dart';
import '../../providers/post_provider2.dart';

class AddPostScreenOnline extends StatefulWidget {
  const AddPostScreenOnline({super.key});

  @override
  State<AddPostScreenOnline> createState() => _AddPostScreenOnlineState();
}

class _AddPostScreenOnlineState extends State<AddPostScreenOnline> {
  // Controllers untuk input teks
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Variabel untuk menyimpan file gambar yang dipilih
  File? _selectedImageFile; // Untuk Android/iOS
  Uint8List? _selectedImageWeb; // Untuk Web

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //------------------- Fungsi Pilih Gambar (Web dan Mobile)
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Logika untuk Web
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedImageWeb =
              result.files.single.bytes; // Web menggunakan Uint8List
        });
      }
    } else {
      // Logika untuk Android/iOS
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    }
  }

  //------------------------------------ Fungsi Membuat Post

  Future<void> _createPost() async {
    // Validasi input
    if (_selectedImageFile == null && _selectedImageWeb == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    // Ambil user yang sedang terautentikasi
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User  not authenticated. Cannot create post.')),
      );
      return;
    }

    // Membuat instance Post
    final post = Post2(
      id: Uuid().v4(), // Menggunakan UUID
      name: _nameController.text,
      description: _descriptionController.text,
      imageUrl: '', // Akan diisi setelah upload
      likes: 0,
      shares: 0,
      userId: user.id, // Menggunakan user ID yang valid
    );

    // Proses upload dan simpan data
    if (kIsWeb && _selectedImageWeb != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengupload gambar...')),
      );
      await uploadAndCreatePostWeb(_selectedImageWeb!, post);
    } else if (_selectedImageFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengupload gambar...')),
      );
      await uploadAndCreatePost(_selectedImageFile!, post);
    }

    // Tampilkan not ifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created successfully!')),
    );

    // Reset form
    _resetForm();
  }

  //------------------------------- Fungsi Reset Form

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImageFile = null;
      _selectedImageWeb = null;
    });
  }

  //---------------------- Widget build untuk menampilkan UI

  @override
  Widget build(BuildContext context) {
    Widget buildImagePreview() {
      if (_selectedImageWeb != null) {
        // Untuk platform Web
        return Image.memory(
          _selectedImageWeb!,
          fit: BoxFit.contain,
        );
      } else if (_selectedImageFile != null) {
        // Untuk platform Android/iOS
        return Image.file(
          _selectedImageFile!,
          fit: BoxFit.contain,
        );
      } else {
        // Jika belum ada gambar dipilih
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar
            AspectRatio(
              aspectRatio: 16 / 9, // Default rasio jika gambar belum ada
              child: buildImagePreview(),
            ),
            const SizedBox(height: 16),
            // TextField untuk Nama
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // TextField untuk Deskripsi
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Tombol untuk memilih gambar
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            // Tombol untuk membuat post
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
