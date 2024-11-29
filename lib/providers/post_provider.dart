import 'dart:io';
// For web support
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // To detect kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

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
    // Siapkan data postingan
    final postData = post.toJson();
    print('Post data being sent: $postData');

    // Kirim data ke Supabase
    final response =
        await Supabase.instance.client.from('posts').insert(postData);

    // Cek status respons
    if (response == null || response.error != null) {
      throw Exception(
          'Failed to create post: ${response.error?.message ?? 'Unknown error'}');
    }

    print('Post created successfully!');
  } catch (e) {
    print('Error creating post: $e');
  }
}

Future<void> uploadAndCreatePost(dynamic file, Post post) async {
  const bucketName = 'creative_hura';
  final path =
      'uploads/${DateTime.now().millisecondsSinceEpoch}_${post.name}.jpg';

  final imageUrl = await uploadImage(bucketName, path, file);
  final user = Supabase.instance.client.auth.currentUser;
  if (imageUrl != null && user != null) {
// Fetch image data to calculate dimensions
    final imageData = await fetchImage(
        imageUrl); // Assuming this function fetches the image data
    final dimensions =
        getImageDimensions(imageData); // Get dimensions from the image data

    final newPost = Post(
      id: post.id,
      name: post.name,
      description: post.description,
      imageUrl: imageUrl,
      likes: post.likes,
      userId: user.id, // Pastikan userId diisi
      width:
          dimensions['width'] != null ? dimensions['width']!.toDouble() : 0.0,
      height:
          dimensions['height'] != null ? dimensions['height']!.toDouble() : 0.0,
    );

    await createPost(newPost); // Panggil fungsi createPost
  } else {
    print('User   not authenticated. Cannot create post.');
  }
}

Future<void> uploadAndCreatePostWeb(Uint8List imageBytes, Post post) async {
  const bucketName = 'creative_hura';
  final path = 'uploads/${DateTime.now().millisecondsSinceEpoch}_image.jpg';

  final imageUrl = await uploadImageWeb(bucketName, path, imageBytes);
  final user = Supabase.instance.client.auth.currentUser;
  if (imageUrl != null && user != null) {
    // Fetch image data to calculate dimensions
    final imageData = await fetchImage(
        imageUrl); // Assuming this function fetches the image data
    final dimensions = getImageDimensions(imageData); // Get dimensions
    final newPost = Post(
      id: post.id,
      name: post.name,
      description: post.description,
      imageUrl: imageUrl,
      likes: post.likes,
      userId: user.id, // Pastikan userId diisi
      width:
          dimensions['width'] != null ? dimensions['width']!.toDouble() : 0.0,
      height:
          dimensions['height'] != null ? dimensions['height']!.toDouble() : 0.0,
    );

    await createPost(newPost); // Panggil fungsi createPost
  } else {
    print('Failed to upload image, post creation aborted.');
  }
}

// ------------------- Post Utility Functions -------------------

// Fetch all posts
Future<List<Post>> getAllPosts() async {
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

Future<Post?> getPostById(String postId) async {
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

//----------------------- Image Manipulation -------------------------
Future<Uint8List> fetchImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

Map<String, int> getImageDimensions(Uint8List imageData) {
  img.Image? decodedImage = img.decodeImage(imageData);
  if (decodedImage != null) {
    return {
      'width': decodedImage.width,
      'height': decodedImage.height,
    };
  } else {
    throw Exception('Failed to decode image');
  }
}

void loadImage(String imageUrl) async {
  try {
    Uint8List imageData = await fetchImage(imageUrl);
    Map<String, int> dimensions = getImageDimensions(imageData);
    int width = dimensions['width']!;
    int height = dimensions['height']!;

    // Now you can use width and height to display the image
    print('Image Width: $width, Height: $height');
    // Display the image using Image.memory or any other widget
  } catch (e) {
    print('Error: $e');
  }
}
