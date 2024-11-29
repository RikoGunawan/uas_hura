import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post.dart';
import '../models/profile.dart';

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

  static Future<Post?> getPostById(String postId) async {
    try {
      final data = await Supabase.instance.client.from('posts').select().match(
          {'id': postId}).maybeSingle(); // Use maybeSingle to fetch one post

      if (data != null) {
        return Post.fromJson(data); // Convert the fetched data to Post2
      } else {
        print('Post not found for ID: $postId');
        return null; // Return null if no post is found
      }
    } catch (e) {
      print('Error fetching post: $e');
      return null; // Return null in case of an error
    }
  }

  static Future<Profile?> getProfileById(String userId) async {
    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        return Profile.fromJson(data); // Pastikan ada metode ini di Profile
      } else {
        print('Profile not found for userId: $userId');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }
}
