import 'package:flutter/material.dart';
import '../../creative_hura_header_widget.dart';
import '../../models/post2.dart';
import '../../providers/post_provider2.dart';
import 'add_post_screen_online.dart';
import 'post_screen.dart';

class CreativeHuraScreen extends StatefulWidget {
  const CreativeHuraScreen({super.key});

  @override
  _CreativeHuraScreenState createState() => _CreativeHuraScreenState();
}

class _CreativeHuraScreenState extends State<CreativeHuraScreen> {
  List<Post2> posts = []; // List to hold fetched posts
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch posts when the widget is initialized
  }

  Future<void> _fetchPosts() async {
    try {
      List<Post2> fetchedPosts = await getAllPosts();

      setState(() {
        // Calculate aspect ratio directly from width and height
        for (var post in fetchedPosts) {
          if (post.width != null && post.height != null) {
            post.aspectRatio = post.width! / post.height!;
          } else {
            post.aspectRatio = null; // Or set a default value if needed
          }
        }
        posts = fetchedPosts;
        isLoading = false; // Update loading state
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Update loading state
      });
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              child: Column(
                children: [
                  const CreativeHuraHeaderWidget(), // HeaderWidget tetap di atas
                  Padding(
                    padding: const EdgeInsets.all(16.0), // Padding untuk konten
                    child: Column(
                      children: [
                        // List of Content Containers
                        ...posts.map((post) => _buildContainer(context, post)),
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
            MaterialPageRoute(
                builder: (context) => const AddPostScreenOnline()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .startFloat, // Moves button to the bottom left
    );
  }

  Widget _buildContainer(BuildContext context, Post2 post) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final containerWidth =
        screenWidth * 0.9; // Set container width to 90% of screen width

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PostScreen(post: post), // Pass the Post2 instance
              ),
            );
          },
          child: Container(
            width: containerWidth, // Use calculated width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio:
                      post.aspectRatio ?? 1.0, // Use aspect ratio from post
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                    child: Image.network(
                      post.imageUrl,
                      fit: BoxFit.scaleDown, // Change this to BoxFit.scaleDown
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.error));
                      },
                    ),
                  ),
                ),
                // Profile Avatar (left side)
                const Positioned(
                  left: 10,
                  bottom: 10,
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                  ),
                ),
                // Like button (bottom-left)
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
                // Share button (bottom-right)
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
