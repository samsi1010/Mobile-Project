import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/all_jobs_page.dart';

class JobDonePage extends StatelessWidget {
  const JobDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Detail'),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Expanded(
              child: buildButton(
                context: context,
                label: 'Lakukan Negosiasi',
                isPrimary: true,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildButton(
                context: context,
                label: 'Daftar Sekarang',
                isPrimary: false, // ini akan membuat tombol pudar
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllJobsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/cleaning.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kebersihan\nSofa Cleaning',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Lokasi: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  TextSpan(
                    text: 'Sitoluama',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Tanggal: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  TextSpan(
                    text: '08 Februari 2025',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Waktu: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  TextSpan(
                    text: '12.00 WIB',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rp 70.000,00',
              style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Membersihkan sofa dari debu, noda, dan kotoran menggunakan metode khusus agar kembali bersih, segar, dan bebas dari bakteri. Cocok untuk yang menginginkan perawatan maksimal pada perabot rumah tangga.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text('1. Pembersihan dilakukan dengan metode vakum, shampooing, atau steam cleaning sesuai jenis bahan sofa.'),
            const Text('2. Tidak termasuk perbaikan atau penggantian kain/struktur sofa.'),
            const Text('3. Memiliki pengalaman dalam pekerjaan kebersihan (lebih disukai).'),
            const Text('4. Mampu bekerja dengan teliti dan hati-hati untuk menjaga kualitas bahan sofa.'),
            const Text('5. Disiplin, rajin, dan memiliki etos kerja yang baik.'),
            const SizedBox(height: 16),
            const Text(
              'Lingkup Pekerjaan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pembatalan oleh klien harus dilakukan minimal 1 hari sebelum jadwal. Jika pekerja tidak datang tanpa pemberitahuan, klien berhak membatalkan atau menjadwalkan ulang.',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required BuildContext context,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? Colors.purple.withOpacity(0.6)
            : Colors.purple.withOpacity(0.6), 
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
