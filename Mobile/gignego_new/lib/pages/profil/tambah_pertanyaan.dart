import 'package:flutter/material.dart';

class TambahPertanyaanPage extends StatefulWidget {
  @override
  _TambahPertanyaanPageState createState() => _TambahPertanyaanPageState();
}

class _TambahPertanyaanPageState extends State<TambahPertanyaanPage> {
  String? selectedHelpOption;

  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pusat Bantuan'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Text('Apa yang bisa kami bantu?', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedHelpOption,
              items: ['-', 'Masalah Akun', 'Kendala Teknis', 'Lainnya'].map((option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHelpOption = value;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: deskripsiController,
              maxLines: 4,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            Text('Nama Lengkap Anda', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: namaController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            Text('Alamat Email Anda', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: emailController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            Text('Nomor Telepon Anda', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: telpController,
              decoration: InputDecoration(border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15),
            Text('Lampiran', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 30),
                    SizedBox(height: 5),
                    Text("Drag atau Drop untuk memilih gambar",
                        style: TextStyle(color: Colors.black45)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),

            // Button Kirim (tambahan)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // aksi kirim di sini
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBB86FC),
                ),
                child: Text("Kirim"),
              ),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("atau"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // aksi hubungi via email
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBB86FC),
                ),
                child: Text("Hubungi Melalui Email"),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
