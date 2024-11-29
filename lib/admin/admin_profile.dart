import 'package:flutter/material.dart';
import 'package:myapp/admin/data_pengunjung.dart';
import 'package:myapp/admin/huraEvents/admin_hura_event_screen.dart';
import 'package:myapp/admin/huraPoints/admin_hura_point_screen.dart';
import 'package:myapp/profile_header_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Profile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .match({'id': user.id}).maybeSingle();

        if (data != null) {
          setState(() {
            profile = Profile.fromJson(data);
          });
        }
      } catch (e) {
        debugPrint('Error loading profile: $e'); // Log error jika diperlukan
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false; // Handle jika user == null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const ProfileHeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 16),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 220, 216, 216),
                          radius: 50.0,
                        ),
                        const SizedBox(height: 16.0),
                        _buildProfileName(),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  _buildContainerVisitor(context),
                  const SizedBox(height: 16.0),
                  _buildContainerEditPoint(context),
                  const SizedBox(height: 16.0),
                  _buildContainerEditEvent(context),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileName() {
    return Text(
      profile?.username ?? 'Profile not available',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildContainerVisitor(BuildContext context) {
    return _buildActionContainer(
      context,
      label: 'Data Pengunjung',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DataPengunjung()),
      ),
    );
  }

  Widget _buildContainerEditPoint(BuildContext context) {
    return _buildActionContainer(
      context,
      label: 'Edit Hura Point',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminHuraPointScreen()),
      ),
    );
  }

  Widget _buildContainerEditEvent(BuildContext context) {
    return _buildActionContainer(
      context,
      label: 'Edit Hura Event',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminHuraEventScreen()),
      ),
    );
  }

  Widget _buildActionContainer(BuildContext context,
      {required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.0,
        width: 150.0,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
