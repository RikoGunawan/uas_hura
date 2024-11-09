import 'dart:convert';

import 'package:http/http.dart' as http; 
import '/models/post.dart';

class PostService {

  static Future<List<Post>> getPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(response.body);

      return data.map((item) => Post.fromJson(item)).toList();
 
    } else {
      throw Exception('Failed to load posts');
    }
  }
}