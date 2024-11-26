import 'package:flutter/material.dart';
import 'package:myapp/profile_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/profile.dart';
import '../../providers/profile_provider.dart';
import '/models/post.dart';
import '../creativeHura/post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      final userId = user.id;
      try {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .match({'id': userId}).maybeSingle();

        if (data != null) {
          setState(() {
            profile = Profile.fromJson(data);
          });
        }
      } catch (e) {
        // Handle error if needed
        print('Error loading profile: $e');
      } finally {
        // Ensure loading state is updated regardless of success or failure
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle case when user is null
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading // Check if loading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 16),
                    child: Column(
                      children: [
                        // Profile Picture
                        const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 220, 216, 216),
                          radius: 50.0,
                        ),
                        const SizedBox(height: 16.0),

                        // Profile Name
                        _buildProfileName(),

                        const SizedBox(height: 16.0),

                        // Stats: Likes and Shares
                        _buildStats(),
                        const SizedBox(height: 16.0),

                        // Content Widgets for selected category
                        _buildCategoryContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileName() {
    return Text(
      profile!.username,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // Stats: Likes and Shares
  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatBox(
          icon: Icons.favorite,
          color: Colors.red,
          value: context.watch<ProfileProvider>().likes.toString(),
        ),
        const SizedBox(width: 30.0),
        _buildStatBox(
          icon: Icons.share,
          color: Colors.green,
          value: context.watch<ProfileProvider>().shares.toString(),
        ),
      ],
    );
  }

  // Stat Box Widget (Likes/Shares)
  Widget _buildStatBox({
    required IconData icon,
    required Color color,
    required String value,
  }) {
    return GestureDetector(
      child: Column(
        children: [
          Icon(icon, size: 20.0, color: color),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Category Content (Posts, Reels, Videos)
  Widget _buildCategoryContent() {
    return GridView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Disable scroll for inner GridView
      shrinkWrap: true, // Allow GridView to take up only the necessary space
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 16.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
        childAspectRatio: 1, // Aspect ratio for the grid items
      ),
      itemCount: 4, // Replace with the actual count of your items
      itemBuilder: (context, index) {
        return _buildPostContainer(context);
      },
    );
  }

  // Content Container for Posts, Reels, and Videos
  Widget _buildPostContainer(BuildContext context) {
    return _buildContainer(context, "Post");
  }

  Widget _buildContainer(BuildContext context, String type) {
    return GestureDetector(
      onTap: () {
        final post = Post(
          name: "Placeholder $type",
          description: "Placeholder Description",
          imageFile: null,
          like: "favorite",
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(post: post),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: MediaQuery.of(context).size.width * 0.4, // Responsive height
        width: MediaQuery.of(context).size.width * 0.4, // Responsive width
      ),
    );
  }

  // Generic Button
}
