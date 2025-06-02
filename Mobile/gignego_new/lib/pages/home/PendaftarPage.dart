import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadApplicants();
  }

  Future<void> loadApplicants() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://192.168.90.59:8081/applications?job_id=${widget.jobId}');
    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);
          final List<dynamic> data = jsonMap['applications'] ?? [];

          setState(() {
            applicants = data.map((item) => Applicant.fromMap(item)).toList();
            isLoading = false;
          });
        } catch (e) {
          print('Error decoding JSON: $e');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat pelamar')),
        );
      }
    } catch (e) {
      print('Error fetching applicants: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan jaringan')),
      );
    }
  }

  // Fungsi untuk mengupdate status pekerjaan menjadi "Proses"
  Future<void> mulaiPekerjaan() async {
    final url = Uri.parse('http://192.168.90.59:8081/jobs/${widget.jobId}/status');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': 'Proses'}), // Mengirim status "Proses"
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pekerjaan telah dimulai dan status diubah ke Proses')),
      );
      loadApplicants(); // Refresh daftar pelamar setelah status berubah
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah status pekerjaan')),
      );
    }
  }

  // Fungsi untuk mengupdate status pekerjaan menjadi "Selesai"
  Future<void> selesaiPekerjaan() async {
    final url = Uri.parse('http://192.168.90.59:8081/jobs/${widget.jobId}/status');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': 'Selesai'}), // Mengirim status "Selesai"
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pekerjaan telah selesai dan status diubah ke Selesai')),
      );
      loadApplicants(); // Refresh daftar pelamar setelah status berubah
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah status pekerjaan')),
      );
    }
  }

  // Fungsi untuk mengupdate status pelamar
  Future<void> updateApplicantStatus(int applicationId, String status) async {
    final url = Uri.parse('http://192.168.90.59:8081/applications/$applicationId');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status pelamar berhasil diperbarui')),
      );
      await loadApplicants(); // Refresh data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status pelamar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pelamar'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(  // Use SingleChildScrollView to prevent overflow
              child: Column(
                children: applicants.map((applicant) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(applicant.userEmail),
                      subtitle: Text(applicant.alasan),
                      trailing: applicant.status == 'menunggu'
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  tooltip: 'Terima',
                                  onPressed: () => updateApplicantStatus(applicant.id, 'diterima'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  tooltip: 'Tolak',
                                  onPressed: () => updateApplicantStatus(applicant.id, 'ditolak'),
                                ),
                              ],
                            )
                          : applicant.status == 'diterima'
                              ? Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Tombol Mulai untuk pekerjaan yang diterima
                                        mulaiPekerjaan();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: Text('Mulai'),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Tombol Selesai untuk pekerjaan yang sudah dimulai
                                        selesaiPekerjaan();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Text('Selesai'),
                                    ),
                                  ],
                                )
                              : Text(
                                  applicant.status[0].toUpperCase() + applicant.status.substring(1),
                                  style: TextStyle(color: Colors.grey),
                                ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
