import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/edit_form_kerja.dart';

class EditStatus extends StatelessWidget {
  const EditStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Detail'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            Expanded(
              child: buildButton(
                context: context,
                label: 'Edit',
                isPrimary: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditFormKerja(),
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 12),
            const Text.rich(
              TextSpan(
                text: 'Alamat: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 153, 53, 153),
                ),
                children: [
                  TextSpan(
                    text: 'Medan',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                text: 'Tanggal: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 153, 53, 153),
                ),
                children: [
                  TextSpan(
                    text: '08 April 2025',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                text: 'Waktu: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 153, 53, 153),
                ),
                children: [
                  TextSpan(
                    text: '12.00 WIB',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rp 150.000,00',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 2, 1, 2),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Membersihkan sofa dari debu, noda, dan kotoran menggunakan metode khusus agar kembali bersih, segar, dan bebas dari bakteri.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 2, 1, 2),
              ),
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 2, 1, 2),
              ),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? const Color.fromARGB(255, 200, 83, 236)
            : const Color.fromARGB(255, 36, 33, 33),
        foregroundColor: Colors.white,
        elevation: 5,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(
          Colors.purpleAccent.withOpacity(0.2),
        ),
      ),
      child: Text(label),
    );
  }
}
