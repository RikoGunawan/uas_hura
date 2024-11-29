import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post.dart';

class SupabaseService {
  static Future<Map<String, dynamic>?> loadProfile(String userId) async {
    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select(
              'id, first_name, last_name, username, bio, imageurl, total_likes, total_shares')
          .eq('id', userId)
          .maybeSingle();
      return data;
    } catch (e) {
      print('Error loading profile: $e');
      return null;
    }
  }

  static Future<String?> uploadImage(
      String bucketName, String path, Uint8List imageBytes) async {
    try {
      final response = await Supabase.instance.client.storage
          .from(bucketName)
          .uploadBinary(path, imageBytes);
      if (response.isEmpty) {
        throw Exception("Upload failed, response is empty");
      }
      return Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(path);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<void> updateProfileImage(String userId, String imageUrl) async {
    await Supabase.instance.client.from('profiles').upsert({
      'id': userId,
      'imageurl': imageUrl,
    });
  }

  static Future<void> updateProfile(String userId, String firstName,
      String lastName, String username, String? imageUrl) async {
    await Supabase.instance.client.from('profiles').upsert({
      'id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'imageurl': imageUrl,
    });
  }

  static Future<List<Post>> getAllPosts() async {
    try {
      final response = await Supabase.instance.client.from('posts').select();
      return (response as List<dynamic>)
          .map((data) => Post.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
