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

  final url = Uri.parse('http://192.168.100.4:8080/applications?job_id=${widget.jobId}');
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



  Future<void> updateApplicantStatus(int applicationId, String status) async {
    final url = Uri.parse('http://192.168.100.4:8080/applications/$applicationId');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status pelamar berhasil diperbarui')),
      );
      await loadApplicants(); // refresh data
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
          : applicants.isEmpty
              ? Center(child: Text('Belum ada pelamar untuk pekerjaan ini'))
              : ListView.builder(
                  itemCount: applicants.length,
                  itemBuilder: (context, index) {
                    final applicant = applicants[index];
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
                                    onPressed: () =>
                                        updateApplicantStatus(applicant.id, 'diterima'),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    tooltip: 'Tolak',
                                    onPressed: () =>
                                        updateApplicantStatus(applicant.id, 'ditolak'),
                                  ),
                                ],
                              )
                            : Text(
                                applicant.status[0].toUpperCase() + applicant.status.substring(1),
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
