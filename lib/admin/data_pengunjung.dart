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
            .match({'id': user.id})
            .maybeSingle();

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
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 600;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16.0),
                        const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 220, 216, 216),
                          radius: 50.0,
                        ),
                        const SizedBox(height: 16.0),
                        _buildProfileName(),
                        const SizedBox(height: 24.0),
                        GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isSmallScreen ? 1 : 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: isSmallScreen ? 2.5 : 1.5,
                          ),
                          children: [
                            _buildContainerVisitor(),
                            _buildContainerData(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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

  Widget _buildContainerVisitor() {
    return GestureDetector(
      onTap: () {
        // Tambahkan logika onTap jika diperlukan
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
    List<Map<String, String>> profileData = [
      {'label': 'First Name', 'value': profile?.firstName ?? 'No First Name'},
      {'label': 'Last Name', 'value': profile?.lastName ?? 'No Last Name'},
      {'label': 'Username', 'value': profile?.username ?? 'No Username'},
      {'label': 'Bio', 'value': profile?.bio ?? 'No Bio'},
      {'label': 'Image URL', 'value': profile?.imageurl ?? 'No Image URL'},
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
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
