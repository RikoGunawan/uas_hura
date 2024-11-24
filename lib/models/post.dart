class Post {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int likes;

  Post({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.likes,
  });

  // Convert JSON to Post object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      likes: json['likes'],
    );
  }

  // Convert Post object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'likes': likes,
    };
  }
}
