import 'dart:io';
import 'dart:typed_data'; // For web support
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // To detect kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post.dart';

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
Future<void> createPost(Post post) async {
  try {
    await Supabase.instance.client.from('posts').insert(post.toJson());
    print('Post created successfully!');
  } catch (e) {
    print('Error creating post: $e');
  }
}

// Upload an image and create a post (Mobile/Desktop)
Future<void> uploadAndCreatePost(dynamic file, Post post) async {
  const bucketName = 'creative_hura';
  final path =
      'uploads/${DateTime.now().millisecondsSinceEpoch}_${post.name}.jpg';

  final imageUrl = await uploadImage(bucketName, path, file);

  if (imageUrl != null) {
    final newPost = Post(
      id: post.id,
      name: post.name,
      description: post.description,
      imageUrl: imageUrl,
      likes: post.likes,
    );

    await createPost(newPost);
  } else {
    print('Failed to upload image, post creation aborted.');
  }
}

// Upload an image and create a post (Web)
Future<void> uploadAndCreatePostWeb(Uint8List imageBytes, Post post) async {
  const bucketName = 'creative_hura';
  final path = 'uploads/${DateTime.now().millisecondsSinceEpoch}_image.jpg';

  final imageUrl = await uploadImageWeb(bucketName, path, imageBytes);

  if (imageUrl != null) {
    final newPost = Post(
      id: post.id,
      name: post.name,
      description: post.description,
      imageUrl: imageUrl,
      likes: post.likes,
    );

    await createPost(newPost);
  } else {
    print('Failed to upload image, post creation aborted.');
  }
}

// ------------------- Post Utility Functions -------------------

// Fetch all posts
Future<List<Post>> getPosts() async {
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

// Update an existing post
Future<void> updatePost(Post post) async {
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
