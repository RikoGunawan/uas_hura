import 'package:flutter/material.dart';
import 'package:myapp/admin/data_pengunjung.dart';
import 'package:myapp/admin/huraEvents/admin_hura_event_screen.dart';
import 'package:myapp/admin/huraPoints/admin_hura_point_screen.dart';
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 8 : 16,
                          horizontal: isSmallScreen ? 12 : 24,
                        ),
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
                      _buildResponsiveGrid(context, isSmallScreen),
                    ],
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

  Widget _buildResponsiveGrid(BuildContext context, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isSmallScreen ? 1 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isSmallScreen ? 3 : 2.5,
        ),
        children: [
          _buildContainerVisitor(context),
          _buildContainerEditPoint(context),
          _buildContainerEditEvent(context),
        ],
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
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
