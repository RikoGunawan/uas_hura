class Profile {
  final String id;
  String firstName;
  String lastName;
  String username;
  String bio;
  final String imageurl;
  final int totalLikes;
  final int totalShares;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.username = 'Unknown User',
    this.bio = '',
    required this.imageurl,
    required this.totalLikes,
    required this.totalShares,
  });

  // Convert JSON to Post object
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
    );
  }
  // Convert Post object to JSON
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
    };
  }
}
