import 'package:flutter/material.dart';

class UbahEmailPage extends StatefulWidget {
  const UbahEmailPage({Key? key}) : super(key: key);

  @override
  State<UbahEmailPage> createState() => _UbahEmailPageState();
}

class _UbahEmailPageState extends State<UbahEmailPage> {
  final TextEditingController _emailBaruController = TextEditingController();

  String emailSaatIni = "yenny@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Email',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Masukkan email baru, jika Anda ingin mengganti email Anda. '
              'Email di profil Anda akan sesuai dengan akun Anda. '
              'Pastikan email Anda bisa dihubungi HR.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),

            const Text("Email saat ini"),
            const SizedBox(height: 6),
            TextField(
              controller: TextEditingController(text: emailSaatIni),
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _emailBaruController,
              decoration: InputDecoration(
                hintText: "Email Baru",
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  elevation: 3,
                ),
                onPressed: () {
                  String emailBaru = _emailBaruController.text;
                  if (emailBaru.isNotEmpty) {
                    // aksi ubah email di sini
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email berhasil diubah ke $emailBaru')),
                    );
                    // Navigator.pop(context); // jika ingin kembali otomatis
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mohon masukkan email baru')),
                    );
                  }
                },
                child: const Text(
                  "Ubah Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
