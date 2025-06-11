import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Applicant {
  final int id;
  final String userEmail;
  final String alasan;
  final String status;

  Applicant({
    required this.id,
    required this.userEmail,
    required this.alasan,
    required this.status,
  });

  factory Applicant.fromMap(Map<String, dynamic> map) {
    return Applicant(
      id: map['id'],
      userEmail: map['user_email'] ?? '',
      alasan: map['alasan'] ?? '',
      status: map['status'] ?? 'menunggu',
    );
  }
}

class PendaftarPage extends StatefulWidget {
  final int jobId;

  const PendaftarPage({Key? key, required this.jobId}) : super(key: key);

  @override
  _PendaftarPageState createState() => _PendaftarPageState();
}

class _PendaftarPageState extends State<PendaftarPage> {
  List<Applicant> applicants = [];
  String? jobStatus;
  bool jobStatusLoading = true;
  bool isLoadingApplicants = true;

  @override
  void initState() {
    super.initState();
    _loadJobStatus(); // Load status pekerjaan yang disimpan
    _fetchApplicants(); // Fetch daftar pelamar
  }

  // Fungsi untuk memuat status pekerjaan yang disimpan
  Future<void> _loadJobStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jobStatus =
          prefs.getString('jobStatus') ?? 'Menunggu'; // Default ke 'Menunggu'
      jobStatusLoading = false;
    });
  }

  // Mengambil daftar pelamar
  Future<void> _fetchApplicants() async {
    setState(() {
      isLoadingApplicants = true;
    });

    final url = Uri.parse(
        'http://192.168.216.59:8081/applications?job_id=${widget.jobId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> data = jsonMap['applications'] ?? [];
        setState(() {
          applicants = data.map((item) => Applicant.fromMap(item)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat daftar pelamar')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan jaringan')));
    } finally {
      setState(() {
        isLoadingApplicants = false;
      });
    }
  }

  Future<void> _updateJobStatus(String status) async {
    final url =
        Uri.parse('http://192.168.216.59:8081/jobs/${widget.jobId}/status');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      setState(() {
        jobStatus = status; // Memperbarui status pekerjaan
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status pekerjaan diubah menjadi $status')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah status pekerjaan')));
    }
  }

  // Fungsi untuk memulai pekerjaan
  Future<void> _startJob() async {
    await _updateJobStatus('Proses');
  }

  // Fungsi untuk menyelesaikan pekerjaan dengan konfirmasi
  Future<void> _finishJob() async {
    bool? isConfirmed = await _showConfirmationDialog(
        context, 'Apakah Anda yakin pekerjaan ini sudah selesai?');
    if (isConfirmed == true) {
      await _updateJobStatus('Selesai');
    }
  }

  // Fungsi untuk menerima pelamar dengan konfirmasi
  Future<void> _acceptApplicant(int applicationId) async {
    bool? isConfirmed = await _showConfirmationDialog(
        context, 'Apakah Anda yakin menerima pelamar ini?');
    if (isConfirmed == true) {
      await _updateApplicantStatus(applicationId, 'diterima');
    }
  }

  // Dialog konfirmasi umum
  Future<bool?> _showConfirmationDialog(
      BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateApplicantStatus(int applicationId, String status) async {
    final url =
        Uri.parse('http://192.168.216.59:8081/applications/$applicationId');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status pelamar diperbarui')),
      );

      // Jika pelamar diterima, perbarui status pekerjaan menjadi "Proses"
      if (status == 'diterima') {
        await _updateJobStatus('Proses'); // Pastikan status pekerjaan diperbarui
      }

      await _fetchApplicants(); // Memuat ulang daftar pelamar setelah status diperbarui
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status pelamar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jobStatusLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Daftar Pelamar')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isLoadingApplicants) {
      return Scaffold(
        appBar: AppBar(title: Text('Daftar Pelamar')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Daftar Pelamar')),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(applicant.userEmail),
              subtitle: Text(applicant.alasan),
              trailing: _buildButtons(applicant),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons(Applicant applicant) {
    // Jika status pelamar masih "menunggu", tampilkan tombol terima dan tolak
    if (applicant.status == 'menunggu') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            tooltip: 'Terima',
            onPressed: () => _acceptApplicant(applicant.id),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            tooltip: 'Tolak',
            onPressed: () => _updateApplicantStatus(applicant.id, 'ditolak'),
          ),
        ],
      );
    }

    // Jika status pelamar sudah diterima, tampilkan tombol untuk memulai pekerjaan
    if (applicant.status == 'diterima') {
      if (jobStatus == 'Menunggu') {
        // Jika status pekerjaan adalah "Menunggu", tampilkan tombol "Mulai"
        return ElevatedButton(
          onPressed: _startJob,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text('Mulai'),
        );
      }

      if (jobStatus == 'Proses') {
        // Jika status pekerjaan adalah "Proses", tampilkan tombol "Selesai"
        return ElevatedButton(
          onPressed: _finishJob,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text('Selesai'),
        );
      }

      if (jobStatus == 'Selesai') {
        // Tidak ada tombol lagi setelah pekerjaan selesai
        return Text('Pekerjaan Selesai', style: TextStyle(color: Colors.green));
      }
    }

    return Text(
      applicant.status[0].toUpperCase() + applicant.status.substring(1),
      style: TextStyle(color: Colors.grey),
    );
  }
}
