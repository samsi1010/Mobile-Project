import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  const JobDetailPage({super.key});

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
                icon: Icons.lock, 
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildButton(
                context: context,
                label: 'Daftar Sekarang',
                isPrimary: true,
                icon: Icons.lock,
                onPressed: () {},
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
                'assets/kendaraan.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kebersihan\nMembersihkan Kendaraan',
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
                    text: '14.00 WIB',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rp 50.000,00',
              style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Mencuci mobil dengan teliti untuk menghilangkan debu, kotoran, dan noda, serta menjaga tampilan kendaraan tetap bersih dan terawat. Cocok untuk yang detail, cekatan, dan memiliki ketelitian dalam membersihkan setiap bagian mobil.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text('1. Membersihkan mobil dari debu, lumpur, dan kotoran menggunakan sabun khusus dan peralatan yang sesuai.'),
            const Text('2. Merawat eksterior kendaraan, termasuk pencucian bodi, kaca, velg, dan ban. Tidak termasuk perbaikan cat atau detailing mendalam.'),
            const Text('3. Memiliki pengalaman dalam mencuci atau merawat kendaraan (lebih disukai).'),
            const Text('4. Mampu bekerja di luar ruangan dalam berbagai kondisi cuaca.'),
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
    IconData? icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.lock, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
