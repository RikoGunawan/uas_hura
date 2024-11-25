import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../add_post_screen.dart';
import '../post_screen.dart';

class CreativeHuraScreen extends StatelessWidget {
  const CreativeHuraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creative Hura'),
        actions: const [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey,
          ),
          SizedBox(width: 16.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section (now in AppBar)
            const SizedBox(height: 16.0),

            // List of Content Containers
            Expanded(
              child: ListView(
                children: [
                  _buildContainer(context, "Post 1"),
                  const SizedBox(height: 16.0),
                  _buildContainer(context, "Post 2"),
                  const SizedBox(height: 16.0),
                  _buildContainer(context, "Post 3"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .startFloat, // Moves button to the bottom left
    );
  }

  Widget _buildContainer(BuildContext context, String type) {
    return GestureDetector(
      onTap: () {
        final post = Post(
          name: "Placeholder $type",
          description: "Placeholder Description",
          imageFile: null, // Null for the image file in this example
          like: "0", // Default like value
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(post: post),
          ),
        );
      },
      child: Container(
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            // Profile Avatar (left side)
            const Positioned(
              left: 10,
              bottom: 10,
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.grey,
              ),
            ),
            // Like Button (bottom-left)
            Positioned(
              bottom: 10,
              right: 50,
              child: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // Handle like button press
                },
              ),
            ),
            // Share Button (bottom-right)
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.green),
                onPressed: () {
                  // Handle share button press
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
