import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class TambahPendidikanPage extends StatefulWidget {
  const TambahPendidikanPage({super.key});

  @override
  State<TambahPendidikanPage> createState() => _TambahPendidikanPageState();
}

class _TambahPendidikanPageState extends State<TambahPendidikanPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedJenjang;
  final TextEditingController institusiController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();

  final List<String> jenjangPendidikan = [
    'Tidak Sekolah',
    'SD',
    'SMP',
    'SMA',
    'D1',
    'D2',
    'D3',
    'D4/S1',
    'S2',
    'S3',
    'Lainnya'
  ];

  bool isDataSaved = false; // Flag untuk menandakan data sudah disimpan
  String savedJenjang = '';
  String savedInstitusi = '';
  String savedJurusan = '';
  String? userEmail; // Variable to store user email

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Memuat data yang disimpan dari SharedPreferences
  }

  // Fungsi untuk memuat data yang disimpan
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail'); // Load email from SharedPreferences

    // Check if the saved email matches the current user's email
    if (email != null && email == userEmail) {
      setState(() {
        isDataSaved = prefs.getBool('isDataSaved') ?? false;
        savedJenjang = prefs.getString('savedJenjang') ?? '';
        savedInstitusi = prefs.getString('savedInstitusi') ?? '';
        savedJurusan = prefs.getString('savedJurusan') ?? '';
      });
    } else {
      // If it's a different email, reset the form data
      setState(() {
        isDataSaved = false;
        savedJenjang = '';
        savedInstitusi = '';
        savedJurusan = '';
      });
    }
  }

  // Fungsi untuk menyimpan data ke SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', userEmail!); // Save email to track the logged-in user
    prefs.setBool('isDataSaved', true);
    prefs.setString('savedJenjang', savedJenjang);
    prefs.setString('savedInstitusi', savedInstitusi);
    prefs.setString('savedJurusan', savedJurusan);
  }

  // Fungsi untuk mengirim data pendidikan ke API
  // Fungsi untuk mengirim data pendidikan ke API
// Fungsi untuk mengirim data pendidikan ke API
Future<void> _submitEducation() async {
  if (_formKey.currentState!.validate()) {
    // Mengambil data yang dimasukkan
    final jenjang = selectedJenjang;
    final institusi = institusiController.text;
    final jurusan = jurusanController.text;

    // Menyimpan email pengguna yang sedang login (misalnya menggunakan SharedPreferences)
    final email = 'user@example.com';  // Ganti dengan email pengguna yang sesuai

    // Memastikan jenjang dan institusi tidak kosong
    if (jenjang == null || institusi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jenjang dan institusi harus diisi')),
      );
      return;
    }

    // Mengirim data pendidikan ke API
    try {
      final response = await http.post(
        Uri.parse('http://192.168.216.59:8081/education'), // Ganti dengan URL API Anda
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,  // Kirimkan email yang sesuai
          'jenjang_pendidikan': jenjang,
          'nama_institusi': institusi,
          'jurusan': jurusan,
        }),
      );

      if (response.statusCode == 201) {
        // Data berhasil disimpan
        setState(() {
          isDataSaved = true;
          savedJenjang = jenjang!;
          savedInstitusi = institusi;
          savedJurusan = jurusan;
        });

        // Menyimpan status ke SharedPreferences
        _saveData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pendidikan berhasil disimpan')),
        );
      } else {
        // Jika gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data pendidikan')),
        );
      }
    } catch (e) {
      // Menangani error jaringan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Pendidikan',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Dropdown untuk memilih jenjang pendidikan
                DropdownButtonFormField<String>(
                  value: isDataSaved ? savedJenjang : selectedJenjang,
                  items: jenjangPendidikan.map((jenjang) {
                    return DropdownMenuItem(
                      value: jenjang,
                      child: Text(jenjang),
                    );
                  }).toList(),
                  onChanged: isDataSaved
                      ? null
                      : (value) {
                          setState(() {
                            selectedJenjang = value;
                          });
                        },
                  decoration: inputDecoration.copyWith(labelText: 'Jenjang Pendidikan'),
                ),
                const SizedBox(height: 16),

                // Text field untuk Nama Institusi
                TextFormField(
                  controller: institusiController,
                  enabled: !isDataSaved, // Disable field jika data sudah disimpan
                  decoration: inputDecoration.copyWith(labelText: 'Nama Institusi'),
                ),
                const SizedBox(height: 16),

                // Text field untuk Jurusan
                TextFormField(
                  controller: jurusanController,
                  enabled: !isDataSaved, // Disable field jika data sudah disimpan
                  decoration: inputDecoration.copyWith(labelText: 'Jurusan (opsional)'),
                ),
                const SizedBox(height: 24),

                // Button untuk batal dan simpan
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.purple),
                        ),
                        child: const Text('Batal', style: TextStyle(color: Colors.purple)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitEducation, // Mengirim data pendidikan ke API
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCD50F3),
                        ),
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
