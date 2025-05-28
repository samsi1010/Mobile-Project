import 'package:flutter/material.dart';
import 'package:flutter_application/pages/profil/edit_profil.dart';
import 'package:flutter_application/pages/profil/setingan.dart';
import 'package:flutter_application/pages/profil/tambah_pengalaman.dart';
import 'package:flutter_application/pages/profil/tambah_pendidikan.dart';
import 'package:flutter_application/pages/profil/tambah_skill.dart';
import 'package:flutter_application/pages/profil/tambah_cv.dart';
import 'package:flutter_application/pages/profil/tambah_pertanyaan.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}
class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      floatingActionButton: CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text("Yenny Angelita Gurning",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text("Profil Belum Lengkap",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14)),
                        Text("Last Update: 20 Maret 2025",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Edit Profil",
                              style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          "Penghasilan Belum \nJatuh Tempo (Rp)",
                                          textAlign: TextAlign.center),
                                      SizedBox(height: 5),
                                      Text("50.000,00",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Container(
                                      width: 1, height: 40, color: Colors.grey),
                                  Column(
                                    children: [
                                      Text("Aset Penghasilan (Rp)",
                                          textAlign: TextAlign.center),
                                      SizedBox(height: 5),
                                      Text("2.000.000,00",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(color: Colors.grey),
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Colors.grey, size: 16),
                                  SizedBox(width: 5),
                                  Expanded(
                                      child: Text(
                                          "Penghasilan belum jatuh tempo akan cair dalam 2 hari setelah waktu kerja")),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ProfileSection(
                            icon: Icons.business_center,
                            title: "Pengalaman Kerja",
                            buttonText: "Tambah Pengalaman Kerja",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TambahPengalamanPage()),
                              );
                            }),
                        ProfileSection(
                            icon: Icons.school,
                            title: "Pendidikan",
                            buttonText: "Tambah Pendidikan",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TambahPendidikanPage()),
                              );
                            }),
                        ProfileSection(
                            icon: Icons.build,
                            title: "Skill",
                            buttonText: "Tambah Skill",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TambahSkillPage()),
                              );
                            }),
                        ProfileSection(
                            icon: Icons.description,
                            title: "CV",
                            buttonText: "Tambah CV",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TambahCVPage()),
                              );
                            }),
                        ProfileSection(
                            icon: Icons.help_outline,
                            title: "Butuh Bantuan",
                            buttonText: "Tambah Pertanyaan",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TambahPertanyaanPage()),
                              );
                            }),
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

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Image.asset("assets/home.png", width: 30, height: 30),
                onPressed: () {}),
            IconButton(
                icon: Image.asset("assets/obrolan.png", width: 30, height: 30),
                onPressed: () {}),
            SizedBox(width: 40),
            IconButton(
                icon:
                    Image.asset("assets/aktivitas.png", width: 30, height: 30),
                onPressed: () {}),
            IconButton(
                icon: Image.asset("assets/profil.png", width: 30, height: 30),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class CustomFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Color(0xFF2979FF),
            Color(0xFF80BF80),
            Color(0xFF15AFFF),
            Color(0xFF00E5FF),
            Color(0xFFFF9800),
            Color(0xFF2979FF),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Icons.add, color: Colors.black, size: 30),
          ),
        ),
      ),
    );
  }
}
