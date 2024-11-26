class Post2 {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int likes;
  final String userId; // Tambahkan user_id

  Post2({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.userId, // Tambahkan user_id ke konstruktor
  });

  // Convert JSON to Post object
  factory Post2.fromJson(Map<String, dynamic> json) {
    return Post2(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      likes: json['likes'],
      userId: json['user_id'], // Ambil user_id dari JSON
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
      'user_id': userId, // Sertakan user_id dalam JSON
    };
  }
}
