import 'package:flutter/material.dart';
import 'package:myapp/screens/profile/edit_profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../home/login_screen.dart';
import 'about_us_screen.dart'; // Pastikan untuk membuat file ini

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutUsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Successfully signed out'),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
