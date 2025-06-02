import 'dart:convert';
import 'package:flutter_application/pages/models/job.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://192.168.90.59:8081/job-postings';

  static Future<List<Job>?> fetchJobs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonMap['data'];
        return jsonData.map((item) => Job.fromMap(item)).toList();
      } else {
        print('Failed to fetch jobs, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      return null;
    }
  }
}