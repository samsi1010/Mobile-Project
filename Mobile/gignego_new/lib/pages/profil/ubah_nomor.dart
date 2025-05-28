import 'package:flutter/material.dart';

class UbahNomorPage extends StatefulWidget {
  const UbahNomorPage({Key? key}) : super(key: key);

  @override
  State<UbahNomorPage> createState() => _UbahNomorPageState();
}

class _UbahNomorPageState extends State<UbahNomorPage> {
  final TextEditingController _nomorBaruController = TextEditingController();

  String nomorSaatIni = "085760360010";

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
          'Nomor Ponsel',
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
              'Nomor ponsel di profil Anda akan sesuai dengan akun Anda. '
              'Pastikan nomor ponsel yang didaftar terhubung dengan Whatsapp.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),

            const Text("Nomor saat ini"),
            const SizedBox(height: 6),
            TextField(
              controller: TextEditingController(text: nomorSaatIni),
              readOnly: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nomorBaruController,
              decoration: const InputDecoration(
                hintText: "Nomor Ponsel Baru",
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
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
                  String nomorBaru = _nomorBaruController.text;
                  if (nomorBaru.isNotEmpty) {
                    // aksi ubah nomor ponsel
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nomor berhasil diubah ke $nomorBaru')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mohon masukkan nomor ponsel baru')),
                    );
                  }
                },
                child: const Text(
                  "Ubah Nomor Ponsel",
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
