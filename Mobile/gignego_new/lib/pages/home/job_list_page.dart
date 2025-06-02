import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/job_detail_page.dart';
import 'package:flutter_application/pages/home/database_helper.dart';
import 'package:flutter_application/pages/home/form_page.dart';
import 'package:flutter_application/pages/home/job_repository.dart';

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
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  int selectedDateIndex = 0;
  int selectedFilterIndex = 0;
  late ScrollController _scrollController;

  List<Job> listPekerjaan = [];

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
    'Proses',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    //  _loadJobs();
    _scrollController = ScrollController();

    listPekerjaan = List<Job>.from(widget.job);

    if (widget.showNotification) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Iklan berhasil ditambahkan!")),
        );

        if (listPekerjaan.isNotEmpty) {
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
   Future<void> _loadJobs() async {
  print('MULAI refreshJobs');
  await JobRepository.refreshJobs();
  print('SELESAI refreshJobs');

  final jobsFromDb = await DatabaseHelper.instance.getJobs();
  print('Jobs dari DB: ${jobsFromDb.length}');

  setState(() {
    listPekerjaan = jobsFromDb;
    print('setState listPekerjaan updated dengan ${listPekerjaan.length} data');
  });
}



  void ambilPekerjaanDariDB() async {
    final dataDariDB = await DatabaseHelper.instance.getJobs();
    setState(() {
      listPekerjaan.clear();
      listPekerjaan.addAll(dataDariDB);
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

  List<Job> _filteredJobs() {
    
    String selectedFullDate = tanggalList[selectedDateIndex]['fullDate'] ?? '';
    String selectedStatus = statusFilter[selectedFilterIndex];

    return listPekerjaan.where((job) {
      bool matchTanggal = isSameDate(job.tanggal, selectedFullDate);
      bool matchStatus =
          selectedStatus == 'Semua' || job.status == selectedStatus;
      bool excludeCurrentUserJob = job.email != widget.currentUserEmail;
      return matchTanggal && matchStatus && excludeCurrentUserJob;
      
    }).toList();
  //     return listPekerjaan; // Tampilkan semua data tanpa filter dulu
  }

//  List<Job> _filteredJobs() {
//   String selectedFullDate = tanggalList[selectedDateIndex]['fullDate'] ?? '';
//   String selectedStatus = statusFilter[selectedFilterIndex];

//   print('Filter tanggal dipilih: $selectedFullDate');
//   print('Filter status dipilih: $selectedStatus');
//   print('Email user sekarang: ${widget.currentUserEmail}');

//   List<Job> filtered = [];

//   for (var job in listPekerjaan) {
//     bool matchTanggal = false;
//     bool matchStatus = false;
//     bool excludeCurrentUserJob = false;

//     // Periksa apakah tanggal pekerjaan cocok dengan yang dipilih
//     if (job.tanggal.isEmpty) {
//       // Jika tanggal kosong, anggap cocok supaya job tetap tampil
//       matchTanggal = true;
//       print('Job id=${job.id} tanggal kosong, dianggap matchTanggal=true');
//     } else {
//       try {
//         final jobDate = DateTime.parse(job.tanggal);
//         final selectedDate = DateTime.parse(selectedFullDate);
//         matchTanggal = jobDate.year == selectedDate.year &&
//             jobDate.month == selectedDate.month &&
//             jobDate.day == selectedDate.day;
//       } catch (e) {
//         print('Error parsing tanggal job.id=${job.id}: ${job.tanggal}');
//       }
//     }

//     // Memastikan status yang dipilih cocok dengan status pekerjaan
//     matchStatus = selectedStatus == 'Semua' || job.status == selectedStatus;
//     excludeCurrentUserJob = job.email != widget.currentUserEmail;

//     print(
//         'Job id=${job.id} tanggal=${job.tanggal} status=${job.status} email=${job.email}');
//     print(
//         '  matchTanggal=$matchTanggal, matchStatus=$matchStatus, excludeCurrentUserJob=$excludeCurrentUserJob');

//     if (matchTanggal && matchStatus && excludeCurrentUserJob) {
//       filtered.add(job);
//     }
//   }

//   // Urutkan hasil filter berdasarkan tanggal pekerjaan
//   filtered.sort((a, b) {
//     DateTime dateA = DateTime.tryParse(a.tanggal) ?? DateTime(2000);
//     DateTime dateB = DateTime.tryParse(b.tanggal) ?? DateTime(2000);
//     return dateA.compareTo(dateB);
//   });

//   print('Jumlah job setelah filter: ${filtered.length}');

//   return filtered;
// }




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
