import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _imageBytes; // Menyimpan data gambar dalam bentuk byte

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final userId = user.id;
      final data = (await Supabase.instance.client
          .from('profiles')
          .select()
          .match({'id': userId}).maybeSingle());

      if (data != null) {
        setState(() {
          _firstNameController.text = data['first_name'] ?? '';
          _lastNameController.text = data['last_name'] ?? '';
          _usernameController.text = data['username'] ?? '';
        });
      }
    }
  }

  Future<String?> uploadImageWeb(
      String bucketName, String path, Uint8List imageBytes) async {
    final user = Supabase.instance.client.auth.currentUser;

    // Periksa apakah pengguna terautentikasi
    if (user == null) {
      print('User  is not authenticated');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User  is not authenticated. Please log in.'),
      ));
      return null;
    }

    try {
      final response = await Supabase.instance.client.storage
          .from(bucketName)
          .uploadBinary(path, imageBytes);

      if (response.isEmpty) {
        throw Exception("Upload failed, response is empty");
      }

      return Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(path);
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading image: $e'),
      ));
      return null;
    }
  }

  Future<void> _selectAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Mengonversi gambar ke Uint8List
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = imageBytes; // Menyimpan bytes gambar
      });

      final userId = Supabase.instance.client.auth.currentUser!.id;
      final path = 'profiles/$userId/profile_photo.png';

      // Mengupload gambar
      final imageUrl =
          await uploadImageWeb('user_profile_photos', path, imageBytes);
      if (imageUrl != null) {
        // Update profil dengan URL gambar
        await Supabase.instance.client.from('profiles').upsert({
          'id': userId,
          'profile_photo_url': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile photo uploaded successfully!'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            label: Text('First Name'),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            label: Text('Last Name'),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            label: Text('Username'),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed:
              _selectAndUploadPhoto, // Memanggil fungsi untuk memilih dan mengupload foto
          child: const Text('Upload Photo'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final userId = Supabase.instance.client.auth.currentUser!.id;
            final firstName = _firstNameController.text;
            final lastName = _lastNameController.text;
            final username = _usernameController.text;

            await Supabase.instance.client.from('profiles').upsert({
              'id': userId,
              'first_name': firstName,
              'last_name': lastName,
              'username': username,
            });

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Saved profile'),
            ));
          },
          child: const Text('Save'),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Supabase.instance.client.auth.signOut(),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
