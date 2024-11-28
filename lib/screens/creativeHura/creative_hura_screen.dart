import 'package:flutter/material.dart';
import '../../creative_hura_header_widget.dart';
import '../../models/post2.dart';
import '../../providers/like_provider.dart';
import '../../providers/post_provider2.dart';
import 'add_post_screen_online.dart';
import 'post_screen.dart';

class CreativeHuraScreen extends StatefulWidget {
  const CreativeHuraScreen({super.key});

  @override
  _CreativeHuraScreenState createState() => _CreativeHuraScreenState();
}

class _CreativeHuraScreenState extends State<CreativeHuraScreen> {
  List<Post2> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    // Mulai loading global
    setState(() {
      isLoading = true;
    });

    try {
      // Ambil data semua post
      List<Post2> fetchedPosts = await getAllPosts();

      // Set data post dengan penyesuaian
      setState(() {
        posts = fetchedPosts.map((post) {
          post.aspectRatio = (post.width != null && post.height != null)
              ? post.width! / post.height!
              : 1.0; // Default aspect ratio jika data width/height kosong
          return post;
        }).toList();
      });
    } catch (e) {
      print('Error fetching posts: $e');

      // Tampilkan pesan error ke user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
    } finally {
      // Pastikan loading dihentikan meskipun ada error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const CreativeHuraHeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: posts
                          .map((post) => _buildContainer(context, post))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddPostScreenOnline()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildContainer(BuildContext context, Post2 post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostScreen(post: post),
              ),
            );
          },
          child: Container(
            width: containerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: post.aspectRatio ?? 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      post.imageUrl,
                      fit: BoxFit.scaleDown,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
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
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      // Optimistic update
                      bool previousLikeStatus = post.isLiked;
                      setState(() {
                        post.isLiked = !post.isLiked;
                        // post.likes += post.isLiked ? 1 : -1;
                      });

                      try {
                        // Panggil fungsi async untuk toggle like
                        await likePost(post);
                      } catch (e) {
                        // Rollback ke status awal jika gagal
                        setState(() {
                          post.isLiked = previousLikeStatus;
                          post.likes += post.isLiked ? 1 : -1;
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
                        await sharePost(post);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Post shared successfully!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to share post')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
