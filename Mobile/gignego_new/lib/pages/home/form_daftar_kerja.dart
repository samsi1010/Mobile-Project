import 'package:flutter/material.dart';

class AlasanPekerjaanPage extends StatefulWidget {
  final String namaPekerjaan;
  final String harga;
  final String lamaPengerjaan;

  const AlasanPekerjaanPage({
    Key? key,
    required this.namaPekerjaan,
    required this.harga,
    required this.lamaPengerjaan,
  }) : super(key: key);

  @override
  _AlasanPekerjaanPageState createState() => _AlasanPekerjaanPageState();
}

class _AlasanPekerjaanPageState extends State<AlasanPekerjaanPage> {
  final _formKey = GlobalKey<FormState>();
  final alasanController = TextEditingController();

  @override
  void dispose() {
    alasanController.dispose();
    super.dispose();
  }

  void kirimAlasan() {
    if (_formKey.currentState!.validate()) {
      // Kalau valid, proses data alasan di sini
      print('Alasan dikirim: ${alasanController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alasan berhasil dikirim!')),
      );
      // Bisa tambahkan navigasi kembali atau logic lain sesuai kebutuhan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alasan Mengambil Pekerjaan'),
        backgroundColor: const Color(0xFF9E61EB),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.namaPekerjaan,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Harga Jasa', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('Waktu Mulai', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.harga, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.lamaPengerjaan, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Text('Alasan Anda Cocok untuk Pekerjaan Ini:', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: alasanController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Jelaskan mengapa Anda cocok dan memilih pekerjaan ini...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tolong isi alasan Anda';
                  }
                  if (value.trim().length < 10) {
                    return 'Alasan terlalu pendek';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tuliskan alasan terbaik Anda dalam beberapa kalimat.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: kirimAlasan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9E61EB),
                    ),
                    child: Text(
                      'Kirim Alasan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Kembali'),
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
