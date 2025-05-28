class Experience {
  final int userId;
  final String position;
  final String companyName;
  final String country;
  final String city;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final String jobFunction;
  final String industry;
  final String level;
  final String employmentType;
  final String description;

  Experience({
    required this.userId,
    required this.position,
    required this.companyName,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.jobFunction,
    required this.industry,
    required this.level,
    required this.employmentType,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'position': position,
      'companyName': companyName,
      'country': country,
      'city': city,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrent': isCurrent,
      'jobFunction': jobFunction,
      'industry': industry,
      'level': level,
      'employmentType': employmentType,
      'description': description,
    };
  }

  // Mengonversi JSON ke objek Experience
  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      userId: json['userId'],
      position: json['position'],
      companyName: json['companyName'],
      country: json['country'],
      city: json['city'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      isCurrent: json['isCurrent'],
      jobFunction: json['jobFunction'],
      industry: json['industry'],
      level: json['level'],
      employmentType: json['employmentType'],
      description: json['description'],
    );
  }
}
