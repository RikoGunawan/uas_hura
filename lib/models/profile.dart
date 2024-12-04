class Profile {
  final String id;
  String firstName;
  String lastName;
  String username;
  String bio;
  final String imageurl;
  final int totalLikes;
  final int totalShares;
  final int totalPoints; // Tambahkan totalPoints untuk leaderboard

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.username = 'Unknown User',
    this.bio = '',
    required this.imageurl,
    required this.totalLikes,
    required this.totalShares,
    required this.totalPoints,  // Inisialisasi totalPoints
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      imageurl: json['imageurl'] ?? '',
      totalLikes: json['total_likes'] ?? 0,
      totalShares: json['total_shares'] ?? 0,
      totalPoints: json['total_points'] ?? 0,  // Parsing totalPoints
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'bio': bio,
      'imageurl': imageurl,
      'total_likes': totalLikes,
      'total_shares': totalShares,
      'total_points': totalPoints,  // Menambahkan totalPoints
    };
  }
}
