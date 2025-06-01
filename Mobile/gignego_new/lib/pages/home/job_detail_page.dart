import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/models/job.dart';
import 'package:flutter_application/pages/home/form_daftar_kerja.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_application/pages/home/chat.dart';

class JobDetailPage extends StatefulWidget {
  final Job job;
  final String currentUserEmail;

  const JobDetailPage({
    super.key,
    required this.job,
    required this.currentUserEmail,
  });

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  List<String> get imagePaths {
    List<String> paths = [];
    if (widget.job.gambar1.isNotEmpty) paths.add(widget.job.gambar1);
    if (widget.job.gambar2.isNotEmpty) paths.add(widget.job.gambar2);
    if (widget.job.gambar3.isNotEmpty) paths.add(widget.job.gambar3);
    return paths;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.job.email == widget.currentUserEmail;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: isOwner
          ? SizedBox.shrink()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final senderEmail = widget.currentUserEmail;
                        final receiverEmail = widget.job.email;
                        final jobId = widget.job.id;

                        if (senderEmail == receiverEmail) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Tidak bisa negosiasi dengan diri sendiri')),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              chatWithEmail: receiverEmail,
                              jobId: jobId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9E61EB),
                      ),
                      child: Text(
                        'Lakukan Negosiasi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final jobId = widget.job.id;
                        if (jobId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('ID pekerjaan tidak valid')));
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AlasanPekerjaanPage(
                              jobPostingId: jobId,
                              userEmail: widget.currentUserEmail,
                              namaPekerjaan: widget.job.namaPekerjaan,
                              harga: 'Rp${widget.job.hargaPekerjaan},00',
                              lamaPengerjaan: widget.job.waktu,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9E61EB),
                      ),
                      child: Text(
                        'Daftar Sekarang',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePaths.isNotEmpty) ...[
              Container(
                height: 180,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imagePaths.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imagePaths[index]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 100),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: imagePaths.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Color(0xFF9E61EB),
                    dotColor: Colors.grey.shade300,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Judul, Lokasi, Tanggal, Waktu & Harga
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.namaPekerjaan,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Lokasi: ',
                              style: TextStyle(
                                  color: const Color(0xFF5E3FBE),
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: widget.job.lokasi ?? '-',
                              style: TextStyle(color: const Color(0xFF636363)),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text("Tanggal: ",
                              style: TextStyle(
                                  color: const Color(0xFF5E3FBE),
                                  fontWeight: FontWeight.w600)),
                          Text(
                            widget.job.tanggal,
                            style: TextStyle(color: Color(0xFF636363)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Waktu: ",
                              style: TextStyle(
                                  color: const Color(0xFF5E3FBE),
                                  fontWeight: FontWeight.w600)),
                          Text(
                            widget.job.waktu,
                            style: TextStyle(color: Color(0xFF636363)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "RP ${widget.job.hargaPekerjaan},00",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            // Tambahkan Divider di sini:
            SizedBox(height: 12),
            Divider(thickness: 1, color: Colors.grey.shade400),
            SizedBox(height: 12),

            Text(
              "Deskripsi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(widget.job.deskripsi),

            SizedBox(height: 20),

            Text(
              "Syarat dan Ketentuan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              widget.job.syaratKetentuan ??
                  "Tidak ada syarat dan ketentuan khusus.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
