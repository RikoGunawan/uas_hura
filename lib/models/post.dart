import 'dart:io';

class Post {
  final String name;
  final String description;
  final File? imageFile; // Optional local file for images
  final String like;

  Post({
    required this.name,
    required this.description,
    this.imageFile, // Optional parameter
    required this.like,
  });

  // A method to check if an image is URL-based or local
  bool get isLocalImage => imageFile != null;
}
