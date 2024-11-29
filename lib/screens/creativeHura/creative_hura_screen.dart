import 'package:flutter/material.dart';
import '../../creative_hura_header_widget.dart';
import '../../models/post2.dart';

import '../../providers/post_provider2.dart';
import 'add_post_screen_online.dart';
import 'post_card.dart';

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
    setState(() {
      isLoading = true;
    });

    try {
      List<Post2> fetchedPosts = await getAllPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
    } finally {
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
                      children:
                          posts.map((post) => PostCard(post: post)).toList(),
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
}
