import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '/models/post.dart';
import '/screens/settings_screen.dart';
import 'post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedCategory = 'Post';

  // Get widgets for the selected category (Post, Reels, Video)
  List<Widget> getPostWidgets() {
    switch (selectedCategory) {
      case 'Post':
        return [
          _buildPostContainer(context),
          const SizedBox(width: 16.0),
          _buildPostContainer(context),
          const SizedBox(width: 16.0),
          _buildPostContainer(context),
        ];
      case 'Reels':
        return [
          _buildReelsContainer(context),
          const SizedBox(width: 16.0),
          _buildReelsContainer(context),
        ];
      case 'Video':
        return [
          _buildVideoContainer(context),
          const SizedBox(width: 16.0),
          _buildVideoContainer(context),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          _buildHeader(),

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

          // Category Buttons (Post, Reels, Video)
          _buildCategoryButtons(),

          const SizedBox(height: 16.0),

          // Content Widgets for selected category
          _buildCategoryContent(),
        ],
      ),
    );
  }

  // App Bar-like Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.red),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  // Profile Name using Consumer for ProfileProvider
  Widget _buildProfileName() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return Text(
          profileProvider.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
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
          Icon(icon, size: 30.0, color: color),
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

  // Category Buttons (Post, Reels, Video)
  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('Post', () {
          setState(() {
            selectedCategory = 'Post';
          });
        }),
        const SizedBox(width: 10),
        _buildButton('Reels', () {
          setState(() {
            selectedCategory = 'Reels';
          });
        }),
        const SizedBox(width: 10),
        _buildButton('Video', () {
          setState(() {
            selectedCategory = 'Video';
          });
        }),
      ],
    );
  }

  // Category Content (Posts, Reels, Videos)
  Widget _buildCategoryContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: getPostWidgets(),
    );
  }

  // Content Container for Posts, Reels, and Videos
  Widget _buildPostContainer(BuildContext context) {
    return _buildContainer(context, "Post");
  }

  Widget _buildReelsContainer(BuildContext context) {
    return _buildContainer(context, "Reels");
  }

  Widget _buildVideoContainer(BuildContext context) {
    return _buildContainer(context, "Video");
  }

  Widget _buildContainer(BuildContext context, String type) {
    return GestureDetector(
      onTap: () {
        final post = Post(
          name: "Placeholder $type",
          description: "Placeholder Description",
          imageFile: null, // Null for the image file in this example
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
        height: 150.0,
        width: 150.0,
      ),
    );
  }

  // Generic Button
  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
