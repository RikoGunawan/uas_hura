import 'package:flutter/material.dart';

import '../../models/post2.dart';
import '../../providers/post_provider2.dart';

class PostScreen extends StatefulWidget {
  final Post2 post; // Change to Post2

  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<Post2?> postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = getPostById(widget.post.id); // Fetch post by ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Post2?>(
        future: postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Post not found'));
          }

          final post = snapshot.data!; // Get the fetched post

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use the post data as needed
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      post.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text(
                              'Image not available',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        );
                      },
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
                        value: post.likes.toString(),
                        onTap: () {
                          // Handle like increment logic here
                        },
                      ),
                      const SizedBox(width: 30.0),
                      _buildStatShare(
                        icon: Icons.share,
                        color: Colors.green,
                        value: post.shares.toString(),
                        onTap: () {
                          // Handle share increment logic here
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Post Title
                  Text(
                    post.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Post Content
                  Text(
                    post.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Additional post details or actions can go here
                ],
              ),
            ),
          );
        },
      ),
    );
  }
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

// Placeholder untuk Kontainer Kosong
Widget _buildEmptyContainer(BuildContext context, Post2 post) {
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
