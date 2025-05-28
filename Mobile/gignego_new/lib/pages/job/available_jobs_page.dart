import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/component/job_card.dart';
import 'package:flutter_application/pages/job/component/tab_filter.dart';
import 'package:flutter_application/pages/job/component/job_selector.dart';
import 'package:flutter_application/pages/job/job_deskrip.dart';
import 'package:flutter_application/pages/job/job_desk.dart';
import 'package:flutter_application/pages/job/edit_status.dart'; 

class AvailableJobsPage extends StatelessWidget {
  const AvailableJobsPage({super.key});

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
          'Pekerjaan Tersedia',
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
                    title: 'Membersihkan Pekarangan Rumah',
                    description: 'Dibutuhkan tenaga untuk membersihkan pekarangan rumah...',
                    time: 'Pengerjaan: 09.00 WIB',
                    color: Colors.purple,
                    icon: Icons.cleaning_services,
                    image: Image.asset('assets/pekarangan.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const JobDeskripPage()),
                      );
                    },
                    statusWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Tersedia',
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
                  const SizedBox(height: 12),
                  JobCard(
                    title: 'Membersihkan Properti Rumah',
                    description: 'Saya membutuhkan tenaga untuk membersihkan dalam rumah saya...',
                    time: 'Pengerjaan: 10.00 WIB',
                    color: Colors.purple,
                    icon: Icons.home,
                    image: Image.asset('assets/sofa.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const JobDeskPage()),
                      );
                    },
                    statusWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Tersedia',
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
