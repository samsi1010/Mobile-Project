import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/job_register.dart'; 
import 'package:flutter_application/pages/job/form_chat.dart'; 

class JobDeskripPage extends StatelessWidget {
  const JobDeskripPage({super.key});

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormChatPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildButton(
                context: context,
                label: 'Daftar Sekarang',
                isPrimary: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobRegisterPage(),
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
                'assets/pekarangan.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kebersihan\nMembersihkan Pekarangan Rumah',
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
                    text: '09.00 WIB',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rp 100.000,00',
              style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Membersihkan halaman rumah dari sampah, dedaunan, dan kotoran, serta merapikan taman agar lebih rapi dan nyaman. Cocok untuk yang teliti, cekatan, dan dapat bekerja di luar ruangan.',
            ),
            const SizedBox(height: 16), 
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text('1. Membersihkan sampah, dedaunan, dan kotoran di halaman rumah.'),
            const Text('2. Merapikan taman, termasuk penyiraman dan pemangkasan ringan.'),
            const Text('3. Tidak termasuk jasa penebangan pohon atau pekerjaan konstruksi.'),
            const Text('4. Memiliki pengalaman dalam pekerjaan kebersihan (lebih disukai).'),
            const Text('5. Mampu bekerja di luar ruangan dalam berbagai kondisi cuaca.'),
            const Text('6. Disiplin, rajin, dan memiliki etos kerja yang baik.'),
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
        backgroundColor: Colors.purple, 
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
