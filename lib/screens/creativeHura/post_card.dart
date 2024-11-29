import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/post2.dart';
import '../../providers/like_provider.dart';
import 'post_screen.dart';

class PostCard extends StatefulWidget {
  final Post2 post;

  const PostCard({super.key, required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Future<bool> _isLikedFuture;

  @override
  void initState() {
    super.initState();
    _isLikedFuture = loadLikeStatus(widget.post.id);
  }

  Future<void> saveLikeStatus(String postId, bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(postId, isLiked);
  }

  Future<bool> loadLikeStatus(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(postId) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _isLikedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading like status'));
          } else {
            bool isLiked =
                snapshot.data ?? false; // Ambil status like dari snapshot

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(post: widget.post),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: widget.post.aspectRatio ?? 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          widget.post.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.grey, size: 50),
                            );
                          },
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 10,
                      bottom: 10,
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 50,
                      child: IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () async {
                          bool previousLikeStatus = isLiked;
                          setState(() {
                            isLiked = !isLiked; // Perbarui status lokal
                            widget.post.isLiked =
                                isLiked; // Perbarui status di model
                          });

                          await saveLikeStatus(
                              widget.post.id, isLiked); // Simpan status baru

                          try {
                            await likePost(widget.post);
                          } catch (e) {
                            setState(() {
                              isLiked =
                                  previousLikeStatus; // Kembalikan status jika gagal
                              widget.post.isLiked =
                                  previousLikeStatus; // Kembalikan status di model
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to toggle like')),
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.green),
                        onPressed: () async {
                          try {
                            await sharePost(widget.post);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Post shared successfully!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to share post')),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
