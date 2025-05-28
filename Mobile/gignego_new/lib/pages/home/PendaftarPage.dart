import 'package:flutter/material.dart';
import 'package:flutter_application/pages/models/applicant.dart'; // buat model Applicant sendiri
import 'package:flutter_application/pages/home/form_page.dart';

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
    _fetchApplicants();
  }

  Future<void> _fetchApplicants() async {
    final data = await ApiService.fetchApplicantsByJobId(widget.jobId);
    setState(() {
      applicants = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (applicants.isEmpty) return Center(child: Text('Belum ada pelamar untuk pekerjaan ini'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pelamar'),
      ),
      body: ListView.builder(
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(applicant.name),
            subtitle: Text(applicant.email),
          );
        },
      ),
    );
  }
}
