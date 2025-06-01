import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/database_helper.dart';
import 'package:flutter_application/pages/home/api_service.dart';

class JobRepository {
  // Sinkronisasi data pekerjaan dari API ke DB lokal
  static Future<void> refreshJobs() async {
    List<Job>? apiJobs = await ApiService.fetchJobs();
    if (apiJobs != null && apiJobs.isNotEmpty) {
      await DatabaseHelper.instance.clearJobs(); // Hapus data lama
      for (var job in apiJobs) {
        await DatabaseHelper.instance.insertJob(job);
      }
    }
  }
}