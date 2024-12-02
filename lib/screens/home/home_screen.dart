import 'package:flutter/material.dart';
import 'package:myapp/widgets/tahura_info_widget.dart';

import '../../models/post.dart';
import '../../services/post_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/main_event_widget.dart';
import '../creativeHura/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLimitedPosts();
  }

  Future<void> _fetchLimitedPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Post> fetchedPosts =
          await fetchPosts(limit: 3); // Ambil hanya 3 postingan
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching limited posts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Guest!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Apakah sudah saatnya rehat sejenak dan berjalan menikmati alam? Ah masa yang indah...',
                    style: TextStyle(
                      color: Color.fromARGB(211, 0, 0, 0),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            const MainEventWidget(),
            const SizedBox(height: 15),
            Stack(
              children: [
                Container(
                  color: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Creative Hura',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap:
                                  true, // Untuk menyesuaikan tinggi ListView
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: PostCard(post: posts[index]),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
            TahuraInfoWidget()
          ],
        ),
      ),
    );
  }
}
