import 'package:flutter/material.dart';
import '../models/post.dart';

import '../providers/post_provider.dart';
import 'add_post_screen.dart';

class CreativeHuraScreen extends StatefulWidget {
  const CreativeHuraScreen({Key? key}) : super(key: key);

  @override
  State<CreativeHuraScreen> createState() => _CreativeHuraScreenState();
}

class _CreativeHuraScreenState extends State<CreativeHuraScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = getPosts(); // Fetch posts from Supabase
  }

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
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading posts: ${snapshot.error}'),
              );
            }

            final posts = snapshot.data ?? [];
            if (posts.isEmpty) {
              return const Center(child: Text('No posts available.'));
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPostContainer(context, post);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          ).then((_) {
            // Refresh posts after returning from AddPostScreen
            setState(() {
              _postsFuture = getPosts();
            });
          });
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildPostContainer(BuildContext context, Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          post.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10.0)),
                  child: Image.network(
                    post.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(
                  height: 200,
                  child: Center(child: Text('No Image')),
                ),
          // Post Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(post.description),
              ],
            ),
          ),
          // Actions (Like, Share)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // Handle like action (optional increment in database)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Liked!')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.green),
                onPressed: () {
                  // Handle share action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shared!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
