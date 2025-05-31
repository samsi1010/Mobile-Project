import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/job_detail_page.dart';
import 'package:flutter_application/pages/home/database_helper.dart';
import 'package:flutter_application/pages/home/form_page.dart'; // pastikan kamu punya ini untuk hapus dari API
import 'package:flutter_application/pages/home/PendaftarPage.dart';
import 'package:flutter_application/pages/home/CustomBottomNavBar.dart';

class StatusKerjaPage extends StatefulWidget {
  final String userEmail; // terima email user

  const StatusKerjaPage({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  _StatusKerjaPageState createState() => _StatusKerjaPageState();
}

class _StatusKerjaPageState extends State<StatusKerjaPage> {
  List<Job> pekerjaan = [];
  int selectedDateIndex = 0;
  int selectedFilterIndex = 0;
  late ScrollController _scrollController;

  final List<String> statusFilter = [
  'Semua',
  'Tersedia',
  'Dalam Proses',
  'Selesai',
  'Kadaluarsa',  // Tambahan filter baru
];


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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    ambilPekerjaanDariDB();
  }

  @override
  void didUpdateWidget(covariant StatusKerjaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userEmail != widget.userEmail) {
      ambilPekerjaanDariDB();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void ambilPekerjaanDariDB() async {
    final dataDariDB =
        await DatabaseHelper.instance.getJobsByEmail(widget.userEmail);
    setState(() {
      pekerjaan = dataDariDB;
    });
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
   void updateJobInList(Job updatedJob) {
      setState(() {
        int index = pekerjaan.indexWhere((job) => job.id == updatedJob.id);
        if (index != -1) {
          pekerjaan[index] = updatedJob;
        } else {
          pekerjaan.add(updatedJob);
        }
      });
    }

  List<Job> _filteredJobs() {
  String selectedFullDate = tanggalList[selectedDateIndex]['fullDate'] ?? '';
  String selectedStatus = statusFilter[selectedFilterIndex];

  return pekerjaan.where((job) {
    bool matchTanggal = isSameDate(job.tanggal, selectedFullDate);

    if (selectedStatus == 'Kadaluarsa') {
      // Tampilkan semua pekerjaan status kadaluarsa, abaikan tanggal
      return job.status == 'Kadaluarsa';
    } else {
      // Untuk status lain, filter berdasarkan tanggal dan status
      bool matchStatus = selectedStatus == 'Semua' || job.status == selectedStatus;
      return matchTanggal && matchStatus;
    }
  }).toList();
}



  // Tambahkan fungsi konfirmasi hapus
  Future<void> konfirmasiHapus(BuildContext context, int jobId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus pekerjaan ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // batal hapus
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // konfirmasi hapus
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      hapusPekerjaan(jobId);
    }
  }

  void hapusPekerjaan(int id) async {
    bool success = await ApiService.deleteJobFromApi(id);
    if (success) {
      await DatabaseHelper.instance.deleteJob(id);
      ambilPekerjaanDariDB();
      print('Pekerjaan dengan id $id berhasil dihapus.');
    } else {
      print('Gagal menghapus pekerjaan dengan id $id dari server.');
    }
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
            'Status Kerja',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
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
                                  currentUserEmail: widget.userEmail,
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    tooltip: 'Edit Pekerjaan',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FormPage(
                                            job: job,
                                            onJobAdded: (updatedJob) {
                                              ambilPekerjaanDariDB();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.people, color: Colors.green),
                                    tooltip: 'Lihat Pelamar',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PendaftarPage(jobId: job.id!),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Hapus Pekerjaan',
                                    onPressed: () {
                                      if (job.id != null) {
                                        konfirmasiHapus(context, job.id!);
                                      }
                                    },
                                  ),
                                ],
                              ),
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

    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormPage(
              onJobAdded: (newJob) {
                ambilPekerjaanDariDB();
              },
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Image.asset(
        'assets/add.png',
        width: 60,
        height: 60,
      ),
    ),

    bottomNavigationBar: CustomBottomNavBar(
      currentIndex: 2,
      currentUserEmail: widget.userEmail,
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
