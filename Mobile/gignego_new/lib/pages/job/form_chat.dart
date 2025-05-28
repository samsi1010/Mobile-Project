import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/chat.dart';

class FormChatPage extends StatelessWidget {
  const FormChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B0082),
        title: const Text(
          'Imel Sari Sinaga',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24.0),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Aktif 23 menit yang lalu',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kamu sedang bertanya mengenai pekerjaan ini',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/pekarangan.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '[Membersihkan Pekarangan Rumah]',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(Icons.calendar_today, size: 14),
                                    SizedBox(width: 4),
                                    Text('08 April 2025, 09.00 - Selesai', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(Icons.location_on, size: 14),
                                    SizedBox(width: 4),
                                    Text('Sitoluama, Toba', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Harga: Rp100.000,00',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          currentUserId: '2', 
                                          partnerId: '1',
                                          partnerName: 'Imel Sari Sinaga',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Perlu dikirim untuk negosiasi',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'Kirim Pesan...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF4B0082)),
                    onPressed: () {
                      // Aksi kirim pesan
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
