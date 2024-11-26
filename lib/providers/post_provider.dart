import 'package:flutter/material.dart';

import '../models/post.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _posts = [];

  List<Post> get posts => _posts;

  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }
}
