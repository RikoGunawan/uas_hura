import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/profile_header_widget.dart';

import '../../models/post.dart';
import '../../models/profile.dart';
import '../../services/supabase_service.dart';
import '../creativeHura/post_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId; // Tambahkan parameter userId

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? profile;
  List<Post> posts = [];
  bool isLoadingProfile = true;
  bool isLoadingPosts = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _fetchPosts();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await SupabaseService.loadProfile(
          widget.userId ?? Supabase.instance.client.auth.currentUser!.id);
      if (data != null) {
        setState(() {
          profile = Profile.fromJson(data);
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  Future<void> _fetchPosts() async {
    setState(() {
      isLoadingPosts = true;
    });

    try {
      // Ambil userId dari profil
      final String currentUserId =
          profile?.id ?? Supabase.instance.client.auth.currentUser!.id;

      // Ambil postingan berdasarkan userId
      List<Post> fetchedPosts =
          await SupabaseService.getPostsByUserId(currentUserId);

      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        isLoadingPosts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoadingProfile
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const ProfileHeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 220, 216, 216),
                          radius: 50.0,
                          backgroundImage: profile?.imageurl != null &&
                                  profile!.imageurl.isNotEmpty
                              ? NetworkImage(profile!.imageurl)
                              : null,
                        ),
                        const SizedBox(height: 16.0),
                        _buildProfileName(),
                        const SizedBox(height: 16.0),
                        _buildStats(),
                        const SizedBox(height: 16.0),
                        isLoadingPosts
                            ? const CircularProgressIndicator()
                            : _buildPostGrid(),
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
      profile?.username ?? 'Unknown User',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatBox(
          icon: Icons.favorite,
          color: Colors.red,
          value: profile?.totalLikes.toString() ?? '0',
        ),
        const SizedBox(width: 30.0),
        _buildStatBox(
          icon: Icons.share,
          color: Colors.green,
          value: profile?.totalShares.toString() ?? '0',
        ),
      ],
    );
  }

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

  Widget _buildPostGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
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
              image: post.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(post.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: post.imageUrl.isEmpty
                ? const Center(
                    child:
                        Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  )
                : null,
          ),
        );
      },
    );
  }
}
