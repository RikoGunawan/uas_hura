import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/profile.dart';

class DataPengunjung extends StatefulWidget {
  const DataPengunjung({super.key});

  @override
  State<DataPengunjung> createState() => _DataPengunjungState();
}

class _DataPengunjungState extends State<DataPengunjung> {
  List<Profile> profiles = [];
  Profile? profile;
  bool isLoading = true;
  final bool _isAppBarVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<List<Profile>> getAllProfiles() async {
    try {
      final response = await Supabase.instance.client.from('profiles').select();
      return (response as List<dynamic>)
          .map((data) => Profile.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching profiles: $e');
      return []; // Kembalikan list kosong jika ada kesalahan
    }
  }

  Future<void> _fetchProfiles() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Profile> fetchedProfiles = await getAllProfiles();
      setState(() {
        profiles = fetchedProfiles;
      });
    } catch (e) {
      'Error fetching profiles: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load profiles')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isAppBarVisible
          ? AppBar(
              title: const Text('Data Pengunjung'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profiles.isEmpty
              ? const Center(child: Text('No profiles found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return _buildProfileCard(profile);
                  },
                ),
    );
  }

  Widget _buildProfileCard(Profile profile) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileField('First Name', profile.firstName),
            _buildProfileField('Last Name', profile.lastName),
            _buildProfileField('Username', profile.username),
            _buildProfileField('Bio', profile.bio),
            _buildProfileField('Image URL', profile.imageurl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(value ?? 'No $label'),
          ),
        ],
      ),
    );
  }
}
