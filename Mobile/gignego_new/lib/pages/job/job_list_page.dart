import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/component/job_card.dart';
import 'package:flutter_application/pages/job/component/tab_filter.dart';
import 'package:flutter_application/pages/job/component/job_selector.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Daftar Pekerjaan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DateSelector(),
            const SizedBox(height: 16),
            const TabFilter(),
            const SizedBox(height: 16),
            const Text(
              "Pekerjaan Hari Ini",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  SizedBox(height: 12),
                  JobCard(
                    title: 'Membersihkan Pekarangan Rumah',
                    description: 'Dibutuhkan tenaga untuk membersihkan pekarangan rumah...',
                    time: 'Pengerjaan: 09.00 WIB',
                    color: Colors.purple,
                    icon: Icons.cleaning_services,
                    image: Image(
                      image: AssetImage('assets/pekarangan.png'),
                      fit: BoxFit.cover,
                    ),
                    statusWidget: Text(
                      'Tersedia',
                      style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                    onTap: _onJobTap,
                  ),
                  SizedBox(height: 12),
                  JobCard(
                    title: 'Mencuci Kendaraan',
                    description: 'Dibutuhkan tenaga untuk mencuci mobil saya...',
                    time: 'Pengerjaan: 14.00 WIB',
                    color: Colors.orange,
                    icon: Icons.directions_car,
                    image: Image(
                      image: AssetImage('assets/kendaraan.png'),
                      fit: BoxFit.cover,
                    ),
                    statusWidget: Text(
                      'Dalam Proses',
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    onTap: _onJobTap,
                  ),
                  SizedBox(height: 12),
                  JobCard(
                    title: 'Membersihkan Properti Rumah',
                    description: 'Saya membutuhkan tenaga untuk membersihkan dalam rumah saya...',
                    time: 'Pengerjaan: 10.00 WIB',
                    color: Colors.purple,
                    icon: Icons.home,
                    image: Image(
                      image: AssetImage('assets/sofa.png'),
                      fit: BoxFit.cover,
                    ),
                    statusWidget: Text(
                      'Tersedia',
                      style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                    onTap: _onJobTap,
                  ),
                  SizedBox(height: 12),
                  JobCard(
                    title: 'Sofa Cleaning',
                    description: 'Dibutuhkan tenaga untuk membersihkan sofa saya...',
                    time: 'Pengerjaan: 12.00 WIB',
                    color: Colors.green,
                    icon: Icons.check_circle,
                    image: Image(
                      image: AssetImage('assets/cleaning.png'),
                      fit: BoxFit.cover,
                    ),
                    statusWidget: Text(
                      'Selesai',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    onTap: _onJobTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Obrolan'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Beri Kerja'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  static void _onJobTap() {
    // Di sini nanti bisa kamu isi untuk pindah halaman
    debugPrint("Job tapped");
  }
}
