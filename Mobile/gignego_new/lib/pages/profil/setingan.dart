import 'package:flutter/material.dart';
import 'package:flutter_application/pages/profil/ubah_email.dart';
import 'package:flutter_application/pages/profil/ubah_nomor.dart';
import 'package:flutter_application/pages/profil/ubah_password.dart';
import 'package:flutter_application/pages/profil/nonaktif_akun.dart';
import 'package:flutter_application/pages/profil/hapus_akun.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application/pages/auth/login.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _userEmail = '';
  String _userPhone = '';

  // Fungsi untuk mengambil data user dari SharedPreferences
  Future<void> _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? 'Email tidak tersedia';
      _userPhone = prefs.getString('user_phone') ?? 'Nomor tidak tersedia';
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();  // Memanggil fungsi untuk mendapatkan data user saat halaman dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Setting",
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  "Pengaturan Akun",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined, color: Colors.purple),
              title: const Text("Email", style: TextStyle(color: Colors.black)),
              subtitle: Text(_userEmail), // Menampilkan email yang diambil
              
            ),
            Divider(),

            // Nomor Ponsel
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone_android, color: Colors.purple),
              title: const Text("Nomor Ponsel", style: TextStyle(color: Colors.black)),
              subtitle: Text(_userPhone), // Menampilkan nomor telepon yang diambil
              
            ),
            Divider(),

            // Password, Nonaktif Akun, Hapus Akun tetap sama
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline, color: Colors.purple),
              title: const Text("Password", style: TextStyle(color: Colors.black)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UbahPasswordPage()),
                );
              },
            ),
            
            Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_forever_outlined, color: Colors.purple),
              title: const Text("Hapus Akun", style: TextStyle(color: Colors.black)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HapusAkunPage()),
                );
              },
            ),
            Divider(),

            const Spacer(),

            // Log out
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
