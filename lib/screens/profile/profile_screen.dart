import 'package:flutter/material.dart';
import 'package:myapp/profile_header_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/post2.dart';
import '../../models/profile.dart';
import '../../providers/post_provider2.dart';
import '../creativeHura/post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? profile;
  List<Post2> posts = [];
  bool isLoadingProfile = true;
  bool isLoadingPosts = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _fetchPosts();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final userId = user.id;
      try {
        final data = await Supabase.instance.client
            .from('profiles')
            .select(
                'id, first_name, last_name, username, bio, imageurl, total_likes, total_shares')
            .eq('id', userId)
            .maybeSingle();

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
    } else {
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
      List<Post2> fetchedPosts = await getAllPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
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
                  ProfileHeaderWidget(),
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

  Widget _buildPostContainer(BuildContext context, String type) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.4,
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
