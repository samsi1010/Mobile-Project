// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter_application/pages/models/job.dart';  // Import model Job

// class ApiService {
//   static const String apiUrl = 'http://192.168.225.39:8080/job-postings';  // Ganti dengan URL API kamu

//   // Fungsi untuk mengirim data pekerjaan baru ke API
//   static Future<bool> createJob(Job job) async {
//   try {
//     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

//     // Pastikan field teks ditambahkan ke dalam form fields
//     request.fields['nama_pekerjaan'] = job.namaPekerjaan;
//     request.fields['deskripsi'] = job.deskripsi;
//     request.fields['lokasi'] = job.lokasi;
//     request.fields['harga_pekerjaan'] = job.hargaPekerjaan.toString();
//     request.fields['syarat_ketentuan'] = job.syaratKetentuan;
//     request.fields['lingkup_kerja'] = job.lingkupKerja;
//     request.fields['jenis_pekerjaan'] = job.jenisPekerjaan;
//     request.fields['status_pekerjaan'] = job.status;

//     // Pastikan gambar ditambahkan dengan benar
//     if (job.gambar1.isNotEmpty) {
//       request.files.add(await http.MultipartFile.fromPath('image1', job.gambar1));
//     }
//     if (job.gambar2.isNotEmpty) {
//       request.files.add(await http.MultipartFile.fromPath('image2', job.gambar2));
//     }
//     if (job.gambar3.isNotEmpty) {
//       request.files.add(await http.MultipartFile.fromPath('image3', job.gambar3));
//     }

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       return true; // Data berhasil dikirim
//     } else {
//       print("Failed to send data: ${response.statusCode}");
//       var responseBody = await http.Response.fromStream(response);  // Ambil response body
//       print('Error response body: ${responseBody.body}');
//       return false;  // Terjadi kesalahan saat mengirim data
//     }
//   } catch (e) {
//     print('Error sending data to API: $e');
//     return false;
//   }
// }
// }
