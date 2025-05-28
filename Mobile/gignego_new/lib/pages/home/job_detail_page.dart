import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/form_daftar_kerja.dart'; // Halaman alasan pekerjaan

class JobDetailPage extends StatelessWidget {
  final Job job;
  final String currentUserEmail; // tambahkan ini

  const JobDetailPage({
    super.key,
    required this.job,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOwner = job.email == currentUserEmail;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: isOwner
          ? SizedBox.shrink() // Jika owner, tombol dihilangkan
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Logika negosiasi
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9E61EB),
                      ),
                      child: Text(
                        'Lakukan Negosiasi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlasanPekerjaanPage(
                              namaPekerjaan: job.namaPekerjaan,
                              harga: 'Rp${job.hargaPekerjaan},00',
                              lamaPengerjaan: job.waktu,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9E61EB),
                      ),
                      child: Text(
                        'Daftar Sekarang',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (job.gambar1.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(job.gambar1),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 10),
            if (job.gambar2.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(job.gambar2),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 10),
            if (job.gambar3.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(job.gambar3),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16),
            Text(
              "${job.jenisPekerjaan}\n${job.namaPekerjaan}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text("Tanggal: ", style: TextStyle(color: Colors.grey[600])),
                Text(
                  job.tanggal,
                  style: TextStyle(color: Color(0xFF9E61EB)),
                ),
              ],
            ),
            Row(
              children: [
                Text("Waktu: ", style: TextStyle(color: Colors.grey[600])),
                Text(
                  job.waktu,
                  style: TextStyle(color: Color(0xFF9E61EB)),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "RP ${job.hargaPekerjaan},00",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Divider(height: 32),
            Text("Deskripsi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(job.deskripsi),
          ],
        ),
      ),
    );
  }
}
