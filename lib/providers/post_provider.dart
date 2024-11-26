import 'package:flutter/material.dart';

import '../models/post.dart';

class PostProvider with ChangeNotifier {
  final List<Post2> _posts = [];

  List<Post2> get posts => _posts;

  void addPost(Post2 post) {
    _posts.add(post);
    notifyListeners();
  }
}
