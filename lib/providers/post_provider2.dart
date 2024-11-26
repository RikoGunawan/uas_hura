import 'dart:io';
import 'dart:typed_data'; // For web support
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // To detect kIsWeb
import 'package:image_picker/image_picker.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post2.dart';

// ------------------- Image Upload Functions -------------------

// Upload image to Supabase (Supports Web & Mobile/Desktop)
Future<String?> uploadImage(
    String bucketName, String path, dynamic file) async {
  try {
    if (kIsWeb && file is Uint8List) {
      // Web: Upload bytes
      await Supabase.instance.client.storage.from(bucketName).uploadBinary(
            path,
            file,
          );
    } else if (file is File) {
      // Mobile/Desktop: Upload file directly
      await Supabase.instance.client.storage.from(bucketName).upload(
            path,
            file,
          );
    } else {
      throw Exception("Unsupported file type");
    }

    // Retrieve the public URL for the uploaded file
    return Supabase.instance.client.storage.from(bucketName).getPublicUrl(path);
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

Future<String?> uploadImageWeb(
    String bucketName, String path, Uint8List imageBytes) async {
  try {
    final response = await Supabase.instance.client.storage
        .from(bucketName)
        .uploadBinary(path, imageBytes);

    if (response.isEmpty) {
      throw Exception("Upload failed, response is empty");
    }

    return Supabase.instance.client.storage.from(bucketName).getPublicUrl(path);
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

// ------------------- Post Management Functions -------------------

// Create a new post
// Create a new post
Future<void> createPost(Post2 post) async {
  try {
    // Siapkan data postingan
    final postData = post.toJson();
    print('Post data being sent: $postData'); // Debug: print post data

    // Kirim data ke Supabase
    final response =
        await Supabase.instance.client.from('posts').insert(postData);

    // Cek apakah response berhasil
    if (response.error == null) {
      print('Post created successfully!');
    } else {
      // Tangani kesalahan jika ada
      print('Error creating post: ${response.error!.message}');
    }
  } catch (e) {
    print('Error creating post: $e');
  }
}

Future<void> uploadAndCreatePost(dynamic file, Post2 post) async {
  const bucketName = 'creative_hura';
  final path =
      'uploads/${DateTime.now().millisecondsSinceEpoch}_${post.name}.jpg';

  final imageUrl = await uploadImage(bucketName, path, file);
  final user = Supabase.instance.client.auth.currentUser;
  if (imageUrl != null && user != null) {
    final newPost = Post2(
      id: post.id,
      name: post.name,
      description: post.description,
      imageUrl: imageUrl,
      likes: post.likes,
      userId: user.id, // Pastikan userId diisi
    );

    await createPost(newPost); // Panggil fungsi createPost
  } else {
    print('User   not authenticated. Cannot create post.');
  }
}

Future<void> uploadAndCreatePostWeb(Uint8List imageBytes, Post2 post) async {
  const bucketName = 'creative_hura';
  final path = 'uploads/${DateTime.now().millisecondsSinceEpoch}_image.jpg';

  final imageUrl = await uploadImageWeb(bucketName, path, imageBytes);
  final user = Supabase.instance.client.auth.currentUser;
  if (imageUrl != null && user != null) {
    final newPost = Post2(
      id: post.id,
      name: post.name,
      description: post.description,
      imageUrl: imageUrl,
      likes: post.likes,
      userId: user.id, // Pastikan userId diisi
    );

    await createPost(newPost); // Panggil fungsi createPost
  } else {
    print('Failed to upload image, post creation aborted.');
  }
}

// ------------------- Post Utility Functions -------------------

// Fetch all posts
Future<List<Post2>> getPosts() async {
  try {
    final response = await Supabase.instance.client.from('posts').select();
    return (response as List<dynamic>)
        .map((data) => Post2.fromJson(data as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching posts: $e');
    return [];
  }
}

// Update an existing post
Future<void> updatePost(Post2 post) async {
  try {
    await Supabase.instance.client
        .from('posts')
        .update({'description': post.description}) // Only updates description
        .eq('id', post.id);
    print('Post updated successfully!');
  } catch (e) {
    print('Error updating post: $e');
  }
}

// Delete a post
Future<void> deletePost(String postId) async {
  try {
    await Supabase.instance.client.from('posts').delete().eq('id', postId);
    print('Post deleted successfully!');
  } catch (e) {
    print('Error deleting post: $e');
  }
}

// ------------------- Image Picker Functions -------------------

// Select a file for upload (Handles Web and Mobile/Desktop)
Future<dynamic> selectFile() async {
  return kIsWeb ? await pickImageWeb() : await pickImageMobile();
}

// Mobile-specific image picker
Future<File?> pickImageMobile() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  return pickedFile != null ? File(pickedFile.path) : null;
}

// Web-specific file picker
Future<Uint8List?> pickImageWeb() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );

  return result?.files.single.bytes;
}
