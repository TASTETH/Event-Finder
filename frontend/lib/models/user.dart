class User {
  final int id;
  final String email;
  final String username;
  final String? fullName;
  final int? age;
  final String? city;
  final String? avatarUrl;
  final double rating;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.age,
    this.city,
    this.avatarUrl,
    required this.rating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      age: json['age'],
      city: json['city'],
      avatarUrl: json['avatar_url'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
