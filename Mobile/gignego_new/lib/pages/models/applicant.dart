class Applicant {
  final int id;
  final String name;
  final String email;

  Applicant({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Applicant.fromMap(Map<String, dynamic> map) {
    return Applicant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
