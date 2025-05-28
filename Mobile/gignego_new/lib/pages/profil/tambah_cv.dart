import 'package:flutter/material.dart';

class TambahCVPage extends StatelessWidget {
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
            OutlinedButton(
              onPressed: () {
                // aksi upload CV
              },
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
                    onPressed: () {
                      // aksi simpan CV
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[300],
                      elevation: 3,
                    ),
                    child: Text('Simpan'),
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

