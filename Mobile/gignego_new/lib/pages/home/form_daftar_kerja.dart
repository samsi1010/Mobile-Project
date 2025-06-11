import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlasanPekerjaanPage extends StatefulWidget {
  final String namaPekerjaan;
  final String harga;
  final String lamaPengerjaan;
  final int jobPostingId;
  final String userEmail;

  const AlasanPekerjaanPage({
    Key? key,
    required this.namaPekerjaan,
    required this.harga,
    required this.lamaPengerjaan,
    required this.jobPostingId,
    required this.userEmail,
  }) : super(key: key);

  @override
  _AlasanPekerjaanPageState createState() => _AlasanPekerjaanPageState();
}

class _AlasanPekerjaanPageState extends State<AlasanPekerjaanPage> {
  final _formKey = GlobalKey<FormState>();
  final alasanController = TextEditingController();
  bool isLoading = false;
  bool _alreadyApplied = false;
  bool _checkingStatus = true;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyApplied();
  }

  @override
  void dispose() {
    alasanController.dispose();
    super.dispose();
  }

  Future<void> checkIfAlreadyApplied() async {
    final url = Uri.parse(
        'http://192.168.216.59:8081/applications/check?job_posting_id=${widget.jobPostingId}&user_email=${widget.userEmail}');
        'http://192.168.90.59:8081/applications/check?job_posting_id=${widget.jobPostingId}&user_email=${widget.userEmail}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _alreadyApplied = data['already_applied'] ?? false;
          _checkingStatus = false;
        });
      } else {
        setState(() {
          _alreadyApplied = false;
          _checkingStatus = false;
        });
      }
    } catch (e) {
      setState(() {
        _alreadyApplied = false;
        _checkingStatus = false;
      });
    }
  }

  Future<bool> kirimAlasanLamaran() async {
    setState(() {
      isLoading = true;
    });

    final data = {
      'job_posting_id': widget.jobPostingId,
      'user_email': widget.userEmail,
      'alasan': alasanController.text.trim(),
    };

      print("Mengirim lamaran dengan job_posting_id: ${widget.jobPostingId}");
  print('Kirim data ke API: ${jsonEncode(data)}');

    final url = Uri.parse('http://192.168.216.59:8081/applications');
    final url = Uri.parse('http://192.168.90.59:8081/applications');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Gagal kirim data: ${response.body}');
      return false;
    }
  }

  void onSubmit() async {
    if (_alreadyApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda sudah mengirim lamaran untuk pekerjaan ini.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      bool sukses = await kirimAlasanLamaran();

      if (sukses) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alasan berhasil dikirim!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim alasan, coba lagi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingStatus) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Alasan Mengambil Pekerjaan'),
          backgroundColor: const Color(0xFF9E61EB),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_alreadyApplied) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Alasan Mengambil Pekerjaan'),
          backgroundColor: const Color(0xFF9E61EB),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Anda sudah mengirim lamaran untuk pekerjaan ini. Terima kasih.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Alasan Mengambil Pekerjaan'),
        backgroundColor: const Color(0xFF9E61EB),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.namaPekerjaan,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Harga Jasa', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('Waktu Mulai', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.harga, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.lamaPengerjaan, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Text('Alasan Anda Cocok untuk Pekerjaan Ini:', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: alasanController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Jelaskan mengapa Anda cocok dan memilih pekerjaan ini...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tolong isi alasan Anda';
                  }
                  if (value.trim().length < 10) {
                    return 'Alasan terlalu pendek';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tuliskan alasan terbaik Anda dalam beberapa kalimat.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9E61EB),
                          ),
                          child: Text(
                            'Kirim Alasan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Kembali'),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
