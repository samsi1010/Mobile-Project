import 'package:flutter/material.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/home_page.dart'; // sesuaikan pathnya


class ValidasiPage extends StatelessWidget {
  final Job job;
  final Function(Job) onJobAdded;

  const ValidasiPage({
    Key? key,
    required this.job,
    required this.onJobAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.1),
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Selamat!\nForm anda sudah dikirim!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Tunggu kabar dari admin agar\nform anda berhasil diupdate ya!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 120,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9E61EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  onJobAdded(job); // Tambah job ke HomePage
                  Navigator.popUntil(context, (route) => route.isFirst); // Kembali ke HomePage
                },
                child: Text(
                  "Beranda",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
