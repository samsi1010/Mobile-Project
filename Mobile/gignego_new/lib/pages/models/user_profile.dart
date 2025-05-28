class UserProfile {
  int? id;
  String name;
  String email;
  String address;
  String occupation;
  DateTime birthDate;
  String? photoUrl;
  String lastUpdate;

  UserProfile({
    this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.occupation,
    required this.birthDate,
    this.photoUrl,
    required this.lastUpdate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      occupation: json['occupation'] ?? '',
      birthDate: json['birth_date'] != null 
          ? DateTime.parse(json['birth_date']) 
          : DateTime.now(),
      photoUrl: json['photo_url'],
      lastUpdate: json['last_update'] ?? DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'occupation': occupation,
      'birth_date': birthDate.toIso8601String(),
      'photo_url': photoUrl,
      'last_update': lastUpdate,
    };
  }

  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? address,
    String? occupation,
    DateTime? birthDate,
    String? photoUrl,
    String? lastUpdate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      birthDate: birthDate ?? this.birthDate,
      photoUrl: photoUrl ?? this.photoUrl,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
