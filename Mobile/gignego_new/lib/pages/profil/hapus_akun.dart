import 'package:flutter/material.dart';

class HapusAkunPage extends StatelessWidget {
  void _konfirmasiHapus(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Konfirmasi',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Apakah kamu yakin ingin menghapus akun secara permanen?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[600],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Akun telah dihapus')),
              );
              Navigator.pop(context);
              // Bisa arahkan ke halaman login atau beranda
            },
            child: const Text(
              'Hapus Akun',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

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
          'Hapus Akun',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menghapus akun bersifat permanen dan tidak bisa dikembalikan. '
              'Semua data, riwayat, dan informasi terkait akun ini akan dihapus selamanya.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _konfirmasiHapus(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 3,
                ),
                child: const Text(
                  'Hapus Akun',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}