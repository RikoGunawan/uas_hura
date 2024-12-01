import 'package:flutter/material.dart';
import 'package:myapp/screens/profile/profile_screen.dart';
import '../../models/post.dart';
import '../../services/post_service.dart';
import 'edit_post_form.dart';
import 'edit_post_screen.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late Future<Post?> postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = getPostById(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPostForm(post: widget.post),
                ),
              );

              if (updated == true) {
                // Refresh data jika postingan diperbarui
                setState(() {
                  postFuture = getPostById(widget.post.id);
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Post'),
                    content: const Text(
                        'Are you sure you want to delete this post?'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false), // Batalkan
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, true), // Konfirmasi
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                try {
                  await deletePost(widget.post.id); // Panggil metode deletePost
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post deleted successfully!')),
                  );

                  // Setelah dihapus, kembali ke halaman sebelumnya
                  Navigator.pop(context,
                      true); // Kembalikan true untuk memberi tahu halaman sebelumnya
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting post: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Post?>(
        future: postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Post not found'));
          }

          final post = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            child: Text('Image not available'),
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
                  Text(
                    post.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
  Widget _buildStatShare({
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
}
