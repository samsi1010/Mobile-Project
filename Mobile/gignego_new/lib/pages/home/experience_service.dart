import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application/pages/models/experience.dart';

class ExperienceService {
  static const String baseUrl = 'http://localhost:8081';

  static Future<bool> addWorkExperience(
    Experience experience, String token) async {
    final url = '$baseUrl/user/${experience.userId}/work-experience';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(experience.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  
        },
      );

      if (response.statusCode == 200) {
        return true; 
      } else {
        print('Failed to add work experience: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  static Future<List<Experience>> getWorkExperience(String userId) async {
    final url = '$baseUrl/user/$userId/work-experience';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => Experience.fromJson(e)).toList();
      } else {
        print('Failed to load work experiences: ${response.body}');
        return []; 
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }
}
