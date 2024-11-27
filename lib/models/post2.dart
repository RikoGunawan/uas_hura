class Post2 {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int likes;
  final int shares;
  final String userId; // Tambahkan user_id
  double? width; // Tambahkan properti width
  double? height; // Tambahkan properti height
  double? aspectRatio; // Tambahkan properti aspectRatio

  Post2({
    required this.id,
    required this.name,
    this.description = '',
    required this.imageUrl,
    this.likes = 0,
    this.shares = 0,
    required this.userId, // Tambahkan user_id ke konstruktor
    this.width, // Tambahkan parameter width
    this.height, // Tambahkan parameter height
    this.aspectRatio, // Tambahkan parameter aspectRatio
  });

  // Convert JSON to Post object
  factory Post2.fromJson(Map<String, dynamic> json) {
    return Post2(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      likes: json['likes'],
      shares: json['shares'],
      userId: json['user_id'], // Ambil user_id dari JSON
      width: json['width']?.toDouble(), // Handle null
      height: json['height']?.toDouble(), // Handle null
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
      'shares': shares,
      'user_id': userId, // Sertakan user_id dalam JSON
      'width': width,
      'height': height,
    };
  }
}
