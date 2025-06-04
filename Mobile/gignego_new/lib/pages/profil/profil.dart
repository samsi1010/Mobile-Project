import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profil.dart';  // Import untuk halaman EditProfilPage
import 'tambah_pengalaman.dart';  // Import untuk halaman TambahPengalamanPage
import 'tambah_pendidikan.dart';  // Import untuk halaman TambahPendidikanPage
import 'tambah_skill.dart';  // Import untuk halaman TambahSkillPage
import 'tambah_cv.dart';  // Import untuk halaman TambahCVPage
import 'tambah_pertanyaan.dart';  // Import untuk halaman TambahPertanyaanPage
import 'setingan.dart';  // Import untuk halaman SettingPage
import 'package:flutter_application/pages/home/CustomBottomNavBar.dart';
import 'package:flutter_application/pages/home/form_page.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/database_helper.dart';


class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  List<Job> pekerjaan = [];
  String? currentUserEmail;
  String? _userName; // Variabel untuk menyimpan nama pengguna

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Memuat nama pengguna saat halaman dimulai
    loadCurrentUserEmail(); // Memuat email pengguna saat halaman dimulai
  }

  // Fungsi untuk memuat nama pengguna dari SharedPreferences
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name');  // Mengambil nama pengguna
    setState(() {
      _userName = userName ?? 'User';  // Jika tidak ada nama, gunakan 'User'
    });
  }

  // Fungsi untuk memuat email pengguna dari SharedPreferences
  Future<void> loadCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    setState(() {
      currentUserEmail = email;
    });
    // Baru ambil pekerjaan setelah email didapat
    ambilPekerjaanDariDB();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Menandakan ini adalah halaman profil
        currentUserEmail: currentUserEmail ?? 'user@example.com', // Ganti dengan email yang sesuai
      ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(height: 200, color: Colors.white),
                Container(
                  margin: EdgeInsets.only(top: 100, left: 20, right: 20),
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFAB74F1),
                        Color(0xFF7C4CB8),
                        Color(0xFF593785)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        // Gantikan "User" dengan nama yang diambil dari SharedPreferences
                        Text(_userName ?? 'User',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text("Profil Belum Lengkap",
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Text("Last Update: 20 Maret 2025",
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Edit Profil", style: TextStyle(color: Colors.white)),
                        ),
                        ProfileSection(
                          icon: Icons.business_center,
                          title: "Pengalaman Kerja",
                          buttonText: "Tambah Pengalaman Kerja",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TambahPengalamanPage()),
                            );
                          },
                        ),
                        ProfileSection(
                          icon: Icons.school,
                          title: "Pendidikan",
                          buttonText: "Tambah Pendidikan",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TambahPendidikanPage()),
                            );
                          },
                        ),
                        ProfileSection(
                          icon: Icons.build,
                          title: "Skill",
                          buttonText: "Tambah Skill",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TambahSkillPage()),
                            );
                          },
                        ),
                        ProfileSection(
                          icon: Icons.description,
                          title: "CV",
                          buttonText: "Tambah CV",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TambahCVPage()),
                            );
                          },
                        ),
                        ProfileSection(
                          icon: Icons.help_outline,
                          title: "Butuh Bantuan",
                          buttonText: "Tambah Pertanyaan",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TambahPertanyaanPage()),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF9E61EB),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage("assets/profile.jpg"),
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  left: 20,
                  child: Image.asset(
                    "assets/gignego.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.settings, color: const Color(0xFF054DC0)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String buttonText;
  final VoidCallback onPressed;

  const ProfileSection({
    required this.icon,
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF054DC0)),
              SizedBox(width: 10),
              Expanded(
                  child: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
          SizedBox(height: 5),
          TextButton.icon(
            onPressed: onPressed,
            icon: Icon(Icons.add, color: Color(0xFF054DC0)),
            label: Text(buttonText,
                style: TextStyle(
                    color: Color(0xFF054DC0), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
