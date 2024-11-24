import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post.dart';

Future<String?> uploadImage(String bucketName, String path, File file) async {
  try {
    final response = await Supabase.instance.client.storage
        .from(bucketName)
        .upload(path, file);

    if (response.isEmpty) {
      throw Exception("Upload failed, response is empty");
    }

    final publicUrl =
        Supabase.instance.client.storage.from(bucketName).getPublicUrl(path);

    return publicUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

Future<void> createPost(Post post) async {
  try {
    await Supabase.instance.client.from('posts').insert(post.toJson());
    print('Post created successfully!');
  } catch (e) {
    print('Error creating post: $e');
  }
}

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

Future<void> updatePost(Post post) async {
  try {
    await Supabase.instance.client
        .from('posts')
        .update(post.toJson())
        .eq('id', post.id);

    print('Post updated successfully!');
  } catch (e) {
    print('Error updating post: $e');
  }
}

Future<void> deletePost(String postId) async {
  try {
    await Supabase.instance.client.from('posts').delete().eq('id', postId);
    print('Post deleted successfully!');
  } catch (e) {
    print('Error deleting post: $e');
  }
}

Future<void> uploadAndCreatePost(File file, Post post) async {
  const bucketName = 'your-bucket-name';
  final path =
      'uploads/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

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
