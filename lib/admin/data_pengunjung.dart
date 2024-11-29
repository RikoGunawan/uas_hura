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
        // Handle error if needed
        print('Error loading profile: $e');
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
              // Wrap the body with SingleChildScrollView
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
                  _buildContainerVisitor(),
                  const SizedBox(height: 16.0),
                  _buildContainerData(),
                  const SizedBox(height: 18.0),
                  _buildContainerData(),
                  const SizedBox(height: 18.0),
                  _buildContainerData(),
                  const SizedBox(height: 18.0),
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

  Widget _buildContainerVisitor() {
    return GestureDetector(
      onTap: () {
        // Add your onTap logic if needed
      },
      child: Container(
        height: 50, // Responsive height
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Data Pengunjung',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContainerData() {
    // Collect all the profile data
    List<Map<String, String>> profileData = [
      {'label': 'First Name', 'value': profile?.firstName ?? 'No First Name'},
      {'label': 'Last Name', 'value': profile?.lastName ?? 'No Last Name'},
      {'label': 'Username', 'value': profile?.username ?? 'No Username'},
      {'label': 'Bio', 'value': profile?.bio ?? 'No Bio'},
      {'label': 'Image URL', 'value': profile?.imageurl ?? 'No Image URL'},
    ];

    return GestureDetector(
      onTap: () {
        // Add your onTap logic if needed
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: profileData.map((data) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    '${data['label']}:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      data['value']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
