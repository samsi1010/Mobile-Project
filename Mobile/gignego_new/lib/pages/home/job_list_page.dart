import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/job_detail_page.dart';
import 'package:flutter_application/pages/home/database_helper.dart';
import 'package:flutter_application/pages/home/form_page.dart';

class JobListPage extends StatefulWidget {
  final List<Job> job;
  final bool showNotification;
  final String selectedCategory;
  final String currentUserEmail;

  const JobListPage({
    Key? key,
    required this.job,
    this.showNotification = false,
    required this.selectedCategory,
    required this.currentUserEmail, // wajib diisi
  }) : super(key: key);

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  int selectedDateIndex = 0;
  int selectedFilterIndex = 0;
  late ScrollController _scrollController;

  List<Map<String, String>> get tanggalList {
    DateTime currentDate = DateTime.now();
    return List.generate(4, (index) {
      DateTime date = currentDate.add(Duration(days: index));
      return {
        'tanggal': date.day.toString(),
        'hari': [
          'Minggu',
          'Senin',
          'Selasa',
          'Rabu',
          'Kamis',
          'Jumat',
          'Sabtu'
        ][date.weekday % 7],
        'fullDate':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      };
    });
  }

  final List<String> statusFilter = [
    'Semua',
    'Tersedia',
    'Dalam Proses',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.showNotification) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Iklan berhasil ditambahkan!")),
        );

        if (widget.job.isNotEmpty) {
          Future.delayed(Duration(milliseconds: 500), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isSameDate(String tanggalJob, String selectedFullDate) {
    try {
      final jobDate = DateTime.parse(tanggalJob);
      final selectedDate = DateTime.parse(selectedFullDate);
      return jobDate.year == selectedDate.year &&
          jobDate.month == selectedDate.month &&
          jobDate.day == selectedDate.day;
    } catch (e) {
      return false;
    }
  }

  List<Job> _filteredJobs() {
    String selectedFullDate = tanggalList[selectedDateIndex]['fullDate'] ?? '';
    String selectedStatus = statusFilter[selectedFilterIndex];

    return widget.job.where((job) {
      bool matchTanggal = isSameDate(job.tanggal, selectedFullDate);
      bool matchStatus =
          selectedStatus == 'Semua' || job.status == selectedStatus;
      bool excludeCurrentUserJob = job.email !=
          widget.currentUserEmail; // Kecualikan pekerjaan user sendiri
      return matchTanggal && matchStatus && excludeCurrentUserJob;
    }).toList();
  }

  // Fungsi untuk menghapus pekerjaan dari database dan server
  void hapusPekerjaan(int id) async {
    bool success =
        await ApiService.deleteJobFromApi(id); // Menghapus dari server
    if (success) {
      await DatabaseHelper.instance
          .deleteJob(id); // Menghapus dari database lokal
      ambilPekerjaanDariDB(); // Memperbarui UI setelah data dihapus
      print('Pekerjaan dengan id $id berhasil dihapus.');
    } else {
      print('Gagal menghapus pekerjaan dengan id $id dari server.');
    }
  }

  // Fungsi untuk mengambil pekerjaan dari database
  void ambilPekerjaanDariDB() async {
    final dataDariDB = await DatabaseHelper.instance.getJobs();
    setState(() {
      widget.job.clear(); // Menghapus data lama
      widget.job.addAll(dataDariDB); // Menambahkan data baru
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 4),
            Text(
              'Daftar Pekerjaan',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTanggal(),
            SizedBox(height: 10),
            _buildFilterStatus(),
            Expanded(
              child: jobs.isEmpty
                  ? Center(child: Text("Belum ada pekerjaan di kategori ini."))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailPage(
                                    job: job,
                                    currentUserEmail: widget.currentUserEmail,
                                  ),
                                ),
                              );
                              },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: job.gambar1.isNotEmpty
                                      ? Image.file(
                                          File(job.gambar1),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.image, size: 60),
                                        )
                                      : Icon(Icons.image, size: 60),
                                ),
                                title: Text(
                                  job.namaPekerjaan,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTanggal() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(tanggalList.length, (index) {
          final selected = selectedDateIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = index),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: selected ? Color(0xFF9E61EB) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Text(
                    'April\n${tanggalList[index]['tanggal']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    tanggalList[index]['hari']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilterStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(statusFilter.length, (index) {
          final selected = selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedFilterIndex = index),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Color(0xFFB599EC) : Color(0xFFF3E9FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusFilter[index],
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
