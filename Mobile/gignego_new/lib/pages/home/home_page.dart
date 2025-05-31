import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home/form_page.dart';
import 'package:flutter_application/pages/home/statuskerja.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/job_list_page.dart';
import 'package:flutter_application/pages/profil/profil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application/pages/home/database_helper.dart';
import 'package:flutter_application/pages/home/chat.dart';
import 'package:flutter_application/pages/home/chatroom.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Job> pekerjaan = [];
  Job? pekerjaanBaru;
  bool isPressed = false;

  String? currentUserEmail;

  // // Fungsi untuk menyimpan pekerjaan ke SharedPreferences
  // void simpanPekerjaanKeSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> pekerjaanList =
  //       pekerjaan.map((job) => job.toMap().toString()).toList();
  //   await prefs.setStringList(
  //       'pekerjaan', pekerjaanList); // Menyimpan pekerjaan dalam bentuk string
  // }

  // // Fungsi untuk mengambil data pekerjaan dari SharedPreferences
  // void ambilPekerjaanDariSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String>? pekerjaanList = prefs.getStringList('pekerjaan');
  //   if (pekerjaanList != null) {
  //     setState(() {
  //       pekerjaan = pekerjaanList
  //           .map((item) => Job.fromMap(item as Map<String, dynamic>))
  //           .toList();
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    loadCurrentUserEmail();
  }

 Future<void> loadCurrentUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('user_email');
  setState(() {
    currentUserEmail = email;
  });
  // Baru ambil pekerjaan setelah email didapat
  ambilPekerjaanDariDB();
}

  // Fungsi untuk mengambil data pekerjaan dari DB dan memperbarui UI
  void ambilPekerjaanDariDB() async {
  final dataDariDB = await DatabaseHelper.instance.getJobs();

  setState(() {
    // Filter pekerjaan, kecuali pekerjaan yang emailnya sama dengan currentUserEmail
    pekerjaan = dataDariDB.where((job) => job.email != currentUserEmail).toList();
  });
}


  void tambahPekerjaan(Job job) async {
    // Cek apakah pekerjaan sudah ada dalam database
    final pekerjaanExist =
        await DatabaseHelper.instance.checkIfJobExists(job.namaPekerjaan);

    if (pekerjaanExist) {
      print("Pekerjaan sudah ada, tidak perlu ditambahkan");
    } else {
      await DatabaseHelper.instance
          .insertJob(job); // Menambahkan pekerjaan baru
      ambilPekerjaanDariDB(); // Refresh data setelah insert
      print('Pekerjaan baru berhasil ditambahkan dan data di-refresh');
    }
  }

  void hapusPekerjaan(int id) async {
    bool success = await ApiService.deleteJobFromApi(id);
    if (success) {
      await DatabaseHelper.instance.deleteJob(id);
      ambilPekerjaanDariDB(); // Refresh UI
      print('Pekerjaan dengan id $id berhasil dihapus.');
    } else {
      print('Gagal menghapus pekerjaan dengan id $id dari server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      bottomNavigationBar:
          _buildBottomNavBar(context, 0,currentUserEmail), // 0 adalah index untuk Home
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Navigasi ke FormPage');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPage(onJobAdded: tambahPekerjaan),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      _buildCategorySection(context),
                      _buildJobSuggestion(),
                      // List pekerjaan yang diambil dari database
                     
                      if (pekerjaanBaru != null)
                        _buildNewJobNotification(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 50, bottom: 80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.greenAccent.shade400,
                Colors.blue.shade900,
              ],
              stops: [0.0, 0.6, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 85),
                  child: Text(
                    "kerja singkat deal cepat",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(dynamic icon, String label, bool isImage) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.purple.shade50,
          radius: 24,
          child: isImage
              ? Image.asset(
                  icon as String,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image,
                        size: 28, color: Colors.red);
                  },
                )
              : Icon(icon as IconData, color: Colors.purple, size: 28),
        ),
        SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/Kebersihan.png", "label": "Kebersihan", "isImage": true},
      {
        "icon": "assets/Perbaikan.png",
        "label": "Perbaikan Rumah",
        "isImage": true
      },
      {
        "icon": "assets/kendaraan.png",
        "label": "Perbaikan Kendaraan",
        "isImage": true
      },
      {
        "icon": "assets/Elektronik.png",
        "label": "Perbaikan Elektronik",
        "isImage": true
      },
      {"icon": "assets/Tutor.png", "label": "Tutor", "isImage": true},
      {"icon": "assets/Rumah.png", "label": "Rumah Tangga", "isImage": true},
      {
        "icon": "assets/Fotografi.png",
        "label": "Fotografi & Videografi",
        "isImage": true
      },
      {"icon": "assets/Lain.png", "label": "Lainnya", "isImage": true},
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 1.5, right: 1.5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 10, right: 16),
            child: Text(
              "Kategori",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          GridView.builder(
            padding: EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print(
                      'Navigasi ke JobListPage: ${categories[index]["label"]}');
                  final pekerjaanKategori = pekerjaan
                      .where((job) =>
                          job.jenisPekerjaan == categories[index]["label"] &&
                          job.status == 'Tersedia')
                      .toList();
                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => JobListPage(
      job: pekerjaanKategori,
      selectedCategory: categories[index]["label"]!, // pakai ! karena yakin tidak null
      currentUserEmail: currentUserEmail!,
    ),
  ),
);

                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        categories[index]["icon"],
                        width: 35,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 70,
                      height: 20,
                      child: Text(
                        categories[index]["label"],
                        style: GoogleFonts.poppins(fontSize: 12),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobSuggestion() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7321DA),
                  Color(0xFFAD7E80),
                  Color(0xFF3A42D2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Setiap tugas yang kamu ambil adalah langkah menuju impianmu",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tak ada pekerjaan yang terlalu kecil, karena dari hal-hal sederhana, kesuksesan besar bisa tumbuh.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewJobNotification(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          if (pekerjaanBaru != null) {
            print(
                'Navigasi ke detail pekerjaan baru: ${pekerjaanBaru!.namaPekerjaan}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobListPage(
                  job: [pekerjaanBaru!],
                  selectedCategory: pekerjaanBaru!.jenisPekerjaan,
                  showNotification: true,
                  currentUserEmail:
                      currentUserEmail!, // Pastikan ini tidak null
                ),
              ),
            );
          }
        },
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(pekerjaanBaru!.gambar1),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image, size: 60),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pekerjaan Baru: ${pekerjaanBaru!.namaPekerjaan}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Kategori: ${pekerjaanBaru!.jenisPekerjaan}",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      Text(
                        "Lihat detail pekerjaan baru Anda!",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Bottom Navigation Bar dengan indikator halaman aktif
  Widget _buildBottomNavBar(BuildContext context, int currentIndex, String? currentUserEmail) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              "assets/home.png",
              0,
              currentIndex,
              () {
                // Sudah di halaman home, tidak perlu navigasi
              },
            ),
           _buildNavItem(
            context,
            "assets/obrolan.png",
            1,
            currentIndex,
            () {
              if (currentUserEmail == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User belum login')),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomListPage(currentUserEmail: currentUserEmail),
                ),
              );
            },
          ),


            _buildNavItem(
              context,
              "assets/aktivitas.png",
              2,
              currentIndex,
              () {
                if (currentUserEmail != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatusKerjaPage(
                        userEmail:
                            currentUserEmail!, // Pakai tanda ! untuk non-null
                      ),
                    ),
                  );
                } else {
                  // Tampilkan pesan kalau user belum login
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User belum login')),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              "assets/profil.png",
              3,
              currentIndex,
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

// // Placeholder classes untuk halaman yang belum dibuat
// class ChatPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat")),
//       body: Center(child: Text("Halaman Chat")),
//       bottomNavigationBar: _buildBottomNavBar(context, 1),
//     );
//   }

// class ActivityPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Aktivitas")),
//       body: Center(child: Text("Halaman Aktivitas")),
//       bottomNavigationBar: _buildBottomNavBar(context, 2),
//     );
//   }

  Widget _buildNavItem(BuildContext context, String iconPath, int index,
      int currentIndex, VoidCallback onPressed) {
    final bool isActive = currentIndex == index;

    return IconButton(
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isActive ? Color(0xFF9E61EB) : Colors.black,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          iconPath,
          width: 35,
          height: 35,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
