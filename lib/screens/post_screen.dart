import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/profile_provider.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Image Placeholder (Container)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300], // Background placeholder
                  child: const Center(
                    child: Text(
                      'Image Placeholder',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Statistik dengan Ikon
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildStatLike(
                    icon: Icons.favorite,
                    color: Colors.red,
                    value: context.watch<ProfileProvider>().likes.toString(),
                    onTap: () {
                      context.read<ProfileProvider>().incrementLikes();
                    },
                  ),
                  const SizedBox(width: 30.0),
                  _buildStatShare(
                    icon: Icons.share,
                    color: Colors.green,
                    value: context.watch<ProfileProvider>().shares.toString(),
                    onTap: () {
                      context.read<ProfileProvider>().incrementShares();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Post Title
              Text(
                widget.post.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),

              // Post Description
              Text(
                widget.post.description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Statistik Like dengan Ikon
  Widget _buildStatLike({
    required IconData icon,
    required Color color,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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

  // Widget Statistik Share dengan Ikon
  Widget _buildStatShare(
      {required IconData icon,
      required Color color,
      required String value,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
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
}

// Placeholder untuk Kontainer Kosong
Widget _buildEmptyContainer(BuildContext context, Post post) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(post: post),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: 100.0, // Tambahkan tinggi default jika diperlukan
        width: 100.0, // Tambahkan lebar default jika diperlukan
      ),
    ),
  );
}
