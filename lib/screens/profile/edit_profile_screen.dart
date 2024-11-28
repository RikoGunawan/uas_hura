import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../home/login_screen.dart';

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
  String? _profileImageUrl; // Menyimpan URL gambar profil

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
          _profileImageUrl =
              data['imageurl']; // Ambil URL gambar profil dari database
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
      final path =
          'profiles/${DateTime.now().millisecondsSinceEpoch}_image.jpg';

      // Mengupload gambar
      final imageUrl = await uploadImageWeb('profile_photos', path, imageBytes);
      if (imageUrl != null) {
        // Update profil dengan URL gambar
        await Supabase.instance.client.from('profiles').upsert({
          'id': userId,
          'imageurl': imageUrl,
        });

        setState(() {
          _profileImageUrl = imageUrl; // Simpan URL gambar yang diupload
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile photo uploaded successfully!'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Menampilkan gambar profil jika ada
          if (_profileImageUrl != null)
            Image.network(
              _profileImageUrl!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 16),
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

              // Log data yang akan diupsert
              print('Upserting data: ${{
                'id': userId,
                'first_name': firstName,
                'last_name': lastName,
                'username': username,
                'imageurl': _profileImageUrl,
              }}');

              try {
                await Supabase.instance.client.from('profiles').upsert({
                  'id': userId,
                  'first_name': firstName,
                  'last_name': lastName,
                  'username': username,
                  'imageurl': _profileImageUrl,
                });

                // Jika response tidak null, berarti upsert berhasil
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Saved profile'),
                ));
              } catch (e) {
                // Tangkap kesalahan dan tampilkan pesan kesalahan
                print('Error upserting profile: $e');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error saving profile: $e'),
                ));
              }
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              // Tunggu hingga pengguna berhasil sign out
              await Supabase.instance.client.auth.signOut();

              // Tampilkan SnackBar setelah berhasil sign out
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Berhasil Sign Out'),
              ));

              // Arahkan pengguna ke halaman login setelah sign out
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
