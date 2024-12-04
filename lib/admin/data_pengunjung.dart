import 'package:flutter/material.dart';
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
  final bool _isAppBarVisible = false;

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
        debugPrint('Error loading profile: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
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
                  Navigator.pop(
                      context); // Pop the current screen and return to the previous screen
                },
              ),
            )
          : null, // AppBar will be null if not visible
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 600;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContainerData(),
                      const SizedBox(height: 18.0),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildContainerData() {
    List<Map<String, String>> profileData = [
      {'label': 'First Name', 'value': profile?.firstName ?? 'No First Name'},
      {'label': 'Last Name', 'value': profile?.lastName ?? 'No Last Name'},
      {'label': 'Username', 'value': profile?.username ?? 'No Username'},
      {'label': 'Bio', 'value': profile?.bio ?? 'No Bio'},
      {'label': 'Image URL', 'value': profile?.imageurl ?? 'No Image URL'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
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
    );
  }
}