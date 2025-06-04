import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'dart:io'; // Untuk menyimpan file yang dipilih

class TambahSkillPage extends StatefulWidget {
  @override
  _TambahSkillPageState createState() => _TambahSkillPageState();
}

class _TambahSkillPageState extends State<TambahSkillPage> {
  File? _selectedFile; // Menyimpan file yang dipilih

  // Fungsi untuk memilih gambar atau dokumen dari perangkat
  Future<void> _pickFile() async {
    final ImagePicker _picker = ImagePicker();

    // Menampilkan dialog untuk memilih antara galeri atau file manager
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery, // Pilih dari galeri
      imageQuality: 80, // Menentukan kualitas gambar
    );

    if (file != null) {
      setState(() {
        _selectedFile = File(file.path); // Menyimpan file yang dipilih
      });
    }
  }

  // Fungsi untuk mengupload file (opsional, jika perlu)
  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pilih file terlebih dahulu!')));
      return;
    }

    // Misalnya Anda ingin mengupload file ke server
    // Anda bisa menggunakan HTTP request untuk mengirim file ke server
    // Contoh pseudocode:
    // var request = http.MultipartRequest('POST', Uri.parse('your-server-url'));
    // request.files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));
    // var response = await request.send();
    
    // Setelah berhasil upload
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Skill berhasil diupload!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Tambah Skill',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              'Upload skill atau jenis proyek yang pernah dikerjakan yang masing-masing sesuai dengan pekerjaan yang akan Anda lamar.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            // Tombol untuk memilih file
            OutlinedButton(
              onPressed: _pickFile, // Fungsi untuk memilih file
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.blue),
              ),
              child: Center(
                child: Text(
                  'Upload Skill',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'maksimal 5MB (.docs, .pdf, .png, .jpg)',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            // Menampilkan file yang dipilih (jika ada)
            _selectedFile != null
                ? Image.file(
                    _selectedFile!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : SizedBox(height: 200, child: Center(child: Text('Tidak ada file yang dipilih'))),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.purple),
                    ),
                    child: Text('Batal', style: TextStyle(color: Colors.purple)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _uploadFile, // Fungsi untuk mengupload file
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCD50F3),
                      elevation: 3,
                    ),
                    child: Text(
    "Simpan", 
    style: TextStyle(
      fontWeight: FontWeight.bold, 
      color: Colors.white, 
    ),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
