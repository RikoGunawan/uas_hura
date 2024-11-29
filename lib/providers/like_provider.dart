import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/post2.dart';

Future<Post2> likePost(Post2 post) async {
  try {
    final supabase = Supabase.instance.client;

    // Cek apakah user sudah menyukai post
    final response = await supabase
        .from('likes')
        .select('id')
        .eq('post_id', post.id)
        .eq('user_id', supabase.auth.currentUser!.id)
        .maybeSingle();

    if (response != null) {
      // Jika sudah menyukai, hapus data like (unlike)
      await supabase.from('likes').delete().eq('id', response['id']);
      post.likes -= 1; // Kurangi jumlah likes
    } else {
      // Jika belum menyukai, tambahkan data like
      await supabase.from('likes').insert({
        'post_id': post.id,
        'user_id': supabase.auth.currentUser!.id,
      });
      post.likes += 1; // Tambahkan jumlah likes
    }

    // Update jumlah likes di tabel posts
    await supabase
        .from('posts')
        .update({'likes': post.likes}).eq('id', post.id);

    return post;
  } catch (e) {
    print('Error toggling like: $e');
    throw Exception('Failed to toggle like');
  }
}

Future<Post2> sharePost(Post2 post) async {
  try {
    final supabase = Supabase.instance.client;

    // Tambahkan data ke tabel shares
    await supabase.from('shares').insert({
      'post_id': post.id,
      'user_id': supabase.auth.currentUser!.id,
    });

    post.shares += 1; // Tambahkan jumlah shares

    // Update jumlah shares di tabel posts
    await supabase
        .from('posts')
        .update({'shares': post.shares}).eq('id', post.id);

    // Update total shares di tabel profiles
    await supabase.from('profiles').update({'total_shares': post.shares}).eq(
        'id', supabase.auth.currentUser!.id);

    return post;
  } catch (e) {
    print('Error sharing post: $e');
    throw Exception('Failed to share post');
  }
}

Future<Post2> fetchPostStats(String postId) async {
  try {
    // Ambil data post berdasarkan ID
    final response = await Supabase.instance.client
        .from('posts')
        .select()
        .eq('id', postId)
        .maybeSingle();

    if (response != null) {
      return Post2.fromJson(response);
    } else {
      throw Exception('Post not found');
    }
  } catch (e) {
    print('Error fetching post stats: $e');
    throw Exception('Failed to fetch post stats');
  }
}
