import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/job_register.dart'; 

class JobDeskPage extends StatelessWidget {
  const JobDeskPage({super.key});

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
                'assets/sofa.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kebersihan\nMembersihkan Property Rumah',
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
                    text: '10.00 WIB',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rp 250.000,00',
              style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Membersihkan bagian dalam dan luar rumah, termasuk menyapu, mengepel, mengelap perabot, dan merapikan ruangan agar tetap bersih dan nyaman. Cocok untuk yang teliti, cekatan, dan memiliki keterampilan dalam pekerjaan kebersihan.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text('1. Melakukan pembersihan menyeluruh pada lantai, perabot, jendela, dan area lainnya sesuai permintaan.'),
            const Text('2. Menangani tugas seperti menyapu, mengepel, mengelap debu, dan merapikan barang. Tidak termasuk perbaikan atau renovasi.'),
            const Text('3. Memiliki pengalaman dalam pekerjaan kebersihan (lebih disukai).'),
            const Text('4. Mampu bekerja secara mandiri atau dalam tim serta menyesuaikan dengan kebutuhan pelanggan.'),
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
        backgroundColor: Colors.purple, 
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
