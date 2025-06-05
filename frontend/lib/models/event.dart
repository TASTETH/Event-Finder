class Event {
  final int id;
  final String title;
  final String address;
  final String briefDescription;
  final String? detailedDescription;
  final String? contactInfo;
  final double latitude;
  final double longitude;
  final String date;
  final bool ageRestriction;
  final int ownerId;
  final String ownerUsername;
  final String category;

  Event({
    required this.id,
    required this.title,
    required this.address,
    required this.briefDescription,
    this.detailedDescription,
    this.contactInfo,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.ageRestriction,
    required this.ownerId,
    required this.ownerUsername,
    required this.category,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      briefDescription: json['brief_description'],
      detailedDescription: json['detailed_description'],
      contactInfo: json['contact_info'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      date: json['date'],
      ageRestriction: json['age_restriction'],
      ownerId: json['owner_id'],
      ownerUsername: json['owner_username'] ?? '',
      category: json['category'] ?? 'Другое',
    );
  }
}
