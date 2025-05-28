import 'package:flutter/material.dart';

class AktivitasPekerjaanPage extends StatelessWidget {
  const AktivitasPekerjaanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tugas"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Tabs
            Row(
              children: [
                _buildFilter("Semua", isActive: true),
                _buildFilter("Dalam Proses"),
                _buildFilter("Selesai"),
              ],
            ),
            const SizedBox(height: 24),

            // List Tugas
            _buildTaskItem(
              title: "Membuat konsep proyek",
              subtitle: "Dipores",
              dateText: "25 Apr",
              dateColor: Colors.red,
            ),
            _buildTaskItem(
              title: "Desain presentasi",
              subtitle: "Hari ini",
              trailingIcon: Icons.check_circle_rounded,
            ),
            _buildTaskItem(
              title: "Menghubungi klien baru",
              subtitle: "Hari ini",
            ),
            _buildTaskItem(
              title: "Kirim laporan bulanan",
              subtitle: "Selesai",
              trailingNumber: 1,
            ),
          ],
        ),
      ),
    );
  }

  // Widget filter
  Widget _buildFilter(String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.purple[100] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.purple : Colors.black,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Widget item tugas
  Widget _buildTaskItem({
    required String title,
    required String subtitle,
    String? dateText,
    Color? dateColor,
    IconData? trailingIcon,
    int? trailingNumber,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 10, color: Colors.purple),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          if (dateText != null)
            Text(
              dateText,
              style: TextStyle(color: dateColor ?? Colors.black),
            ),
          if (trailingIcon != null)
            Icon(trailingIcon, color: Colors.purple),
          if (trailingNumber != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                trailingNumber.toString(),
                style: const TextStyle(color: Colors.purple),
              ),
            ),
        ],
      ),
    );
  }
}
