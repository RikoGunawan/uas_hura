import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/creative_hura_header_widget.dart';
import '../../models/post.dart';

import '../../models/profile.dart';
import '../../services/post_service.dart';
import '../../services/supabase_service.dart';
import 'post_card.dart';

class CreativeHuraScreen extends StatefulWidget {
  const CreativeHuraScreen({super.key});

  @override
  _CreativeHuraScreenState createState() => _CreativeHuraScreenState();
}

class _CreativeHuraScreenState extends State<CreativeHuraScreen> {
  List<Post> posts = [];
  bool isLoading = true;
  Profile? profile;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _loadProfile(); // Panggil metode untuk memuat profil
  }

  Future<void> _fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Post> fetchedPosts = await getAllPosts();
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

  Future<Profile?> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await SupabaseService.loadProfile(user.id);
        if (data != null) {
          return Profile.fromJson(data);
        }
      } catch (e) {
        print('Error loading profile: $e');
      }
    }
    return null; // Kembalikan null jika tidak ada profil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Profile?>(
        future: _loadProfile(), // Panggil metode untuk memuat profil
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No profile found.'));
          } else {
            profile =
                snapshot.data; // Inisialisasi profile dengan data yang diambil

            return SingleChildScrollView(
              child: Column(
                children: [
                  const CreativeHuraHeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: posts
                          .map((post) => PostCard(
                                post: post,
                                // Gunakan profile yang sudah diisi
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
