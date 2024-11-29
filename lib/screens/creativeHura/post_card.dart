import 'package:flutter/material.dart';
import 'package:myapp/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/post.dart';
import '../../models/profile.dart';
import '../../providers/like_provider.dart';
import '../profile/profile_screen.dart';
import 'post_screen.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Future<bool> _isLikedFuture;
  Profile? postAuthorProfile;

  @override
  void initState() {
    super.initState();
    _isLikedFuture = loadLikeStatus(widget.post.id);
    fetchAuthorProfile();
  }

  Future<void> fetchAuthorProfile() async {
    try {
      Profile? profile =
          await SupabaseService.getProfileById(widget.post.userId);
      setState(() {
        postAuthorProfile = profile;
      });
    } catch (e) {
      print('Error fetching author profile: $e');
    }
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
            bool isLiked = snapshot.data ?? false;

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
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(userId: widget.post.userId),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              postAuthorProfile?.imageurl != null &&
                                      postAuthorProfile!.imageurl.isNotEmpty
                                  ? NetworkImage(postAuthorProfile!.imageurl)
                                  : null,
                          child: postAuthorProfile == null ||
                                  postAuthorProfile!.imageurl.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
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
                            isLiked = !isLiked;
                            widget.post.isLiked = isLiked;
                          });

                          await saveLikeStatus(widget.post.id, isLiked);

                          try {
                            await likePost(widget.post);
                          } catch (e) {
                            setState(() {
                              isLiked = previousLikeStatus;
                              widget.post.isLiked = previousLikeStatus;
                            });
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
                          } catch (e) {
                            print('Failed to share post');
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
