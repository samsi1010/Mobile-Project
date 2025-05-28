class Profile {
  final String name;
  final String email;
  final String address;
  final String job;
  final String birthdate;
  final String photo;

  Profile({
    required this.name,
    required this.email,
    required this.address,
    required this.job,
    required this.birthdate,
    required this.photo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      job: json['job'],
      birthdate: json['birthdate'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'job': job,
      'birthdate': birthdate,
      'photo': photo,
    };
  }
}
