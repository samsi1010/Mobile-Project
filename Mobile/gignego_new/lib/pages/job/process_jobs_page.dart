import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/component/job_card.dart';
import 'package:flutter_application/pages/job/component/job_selector.dart';
import 'package:flutter_application/pages/job/component/tab_filter.dart';
import 'package:flutter_application/pages/job/job_detail.dart';
import 'package:flutter_application/pages/job/edit_status.dart'; 

class ProcessJobsPage extends StatelessWidget {
  const ProcessJobsPage({super.key});

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
          'Pekerjaan Dalam Proses',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const DateSelector(),
            const TabFilter(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  JobCard(
                    title: 'Mencuci Kendaraan',
                    description: 'Dibutuhkan tenaga untuk mencuci mobil saya...',
                    time: 'Pengerjaan: 14.00 WIB',
                    color: Colors.orange,
                    icon: Icons.directions_car,
                    image: Image.asset('assets/kendaraan.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const JobDetailPage()),
                      );
                    },
                    statusWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Dalam Proses',
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditStatus()),
                            );
                          },
                          child: const Icon(Icons.edit, color: Colors.grey, size: 18),
                        ),
                      ],
                    ),
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
        currentIndex: 0,
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
}
