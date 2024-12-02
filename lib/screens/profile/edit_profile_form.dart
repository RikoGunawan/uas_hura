import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/screens/home/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _imageBytes;
  String? _profileImageUrl;

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
      final data = await SupabaseService.loadProfile(user.id);
      if (data != null) {
        setState(() {
          _firstNameController.text = data['first_name'] ?? '';
          _lastNameController.text = data['last_name'] ?? '';
          _usernameController.text = data['username'] ?? '';
          _profileImageUrl = data['imageurl'];
        });
      }
    }
  }

  Future<void> _selectAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
      });

      final userId = Supabase.instance.client.auth.currentUser!.id;
      final path =
          'profiles/${DateTime.now().millisecondsSinceEpoch}_image.jpg';

      final imageUrl =
          await SupabaseService.uploadImage('profile_photos', path, imageBytes);
      if (imageUrl != null) {
        await SupabaseService.updateProfileImage(userId, imageUrl);
        setState(() {
          _profileImageUrl = imageUrl;
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
          onPressed: _selectAndUploadPhoto,
          child: const Text('Upload Photo'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final userId = Supabase.instance.client.auth.currentUser!.id;
            final firstName = _firstNameController.text;
            final lastName = _lastNameController.text;
            final username = _usernameController.text;

            try {
              await SupabaseService.updateProfile(
                  userId, firstName, lastName, username, _profileImageUrl);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Saved profile'),
              ));
            } catch (e) {
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
            await Supabase.instance.client.auth.signOut();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Successfully signed out'),
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}