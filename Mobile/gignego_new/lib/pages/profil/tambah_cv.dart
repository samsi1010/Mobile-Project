import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'dart:io'; // Untuk menyimpan gambar yang dipilih

class TambahCVPage extends StatefulWidget {
  @override
  _TambahCVPageState createState() => _TambahCVPageState();
}

class _TambahCVPageState extends State<TambahCVPage> {
  File? _selectedImage; // Menyimpan gambar yang dipilih

  // Fungsi untuk memilih gambar dari galeri atau kamera
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Menampilkan dialog untuk memilih antara galeri atau kamera
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // Pilih dari galeri
      imageQuality: 80, // Menentukan kualitas gambar
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Menyimpan gambar yang dipilih
      });
    }
  }

  // Fungsi untuk mengupload gambar ke server (opsional, jika perlu)
  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pilih gambar terlebih dahulu!')));
      return;
    }
    
    // Misalnya Anda ingin mengupload gambar ke server
    // Anda bisa menggunakan HTTP request untuk mengirim file ke server
    // Contoh pseudocode:
    // var request = http.MultipartRequest('POST', Uri.parse('your-server-url'));
    // request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
    // var response = await request.send();
    
    // Setelah berhasil upload
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gambar berhasil diupload!')));
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
          'Tambah CV',
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
              'Upload maksimum 5 CV yang masing-masing sesuai dengan pekerjaan yang akan Anda lamar.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            // Tombol untuk memilih gambar
            OutlinedButton(
              onPressed: _pickImage, // Fungsi untuk memilih gambar
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.blue),
              ),
              child: Center(
                child: Text(
                  'Upload CV',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'maksimal 5MB (.docs, .pdf)',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            // Menampilkan gambar yang dipilih (jika ada)
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : SizedBox(height: 200, child: Center(child: Text('Tidak ada gambar yang dipilih'))),
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
                    onPressed: _uploadImage, // Fungsi untuk mengupload gambar
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
