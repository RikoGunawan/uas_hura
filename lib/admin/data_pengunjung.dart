import 'package:flutter/material.dart';
import 'package:myapp/profile_header_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/profile.dart';

class DataPengunjung extends StatefulWidget {
  const DataPengunjung({super.key});

  @override
  State<DataPengunjung> createState() => _DataPengunjungState();
}

class _DataPengunjungState extends State<DataPengunjung> {
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
        'Error loading profile: $e'; // Handle error if needed
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false; // Handle case when user is null
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
                  _buildContainerData(context),
                  const SizedBox(height: 16.0),
                  _buildContainerData(context),
                  const SizedBox(height: 16.0),
                  _buildContainerData(context),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileName() {
    if (profile == null) {
      return const Text(
        'Profile not available',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
    return Text(
      profile!.username,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildContainerVisitor(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 55, // Responsive height
        width: 250, // Responsive width
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Data Pengunjung',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContainerData(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 65, // Responsive height
        width: 250, // Responsive width
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Data Pengunjung',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }
}
