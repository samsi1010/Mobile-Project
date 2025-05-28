import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JobListPage(),
    );
  }
}

class JobListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
              "Kebersihan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Daftar Pekerjaan",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          DateSelector(),
          SizedBox(height: 10),
          StatusFilter(),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                JobCard(
                  title: "Membersihkan Pekarangan Rumah",
                  description: "Dibutuhkan tenaga untuk membersihkan pekarangan rumah...",
                  time: "09.00 WIB",
                ),
                JobCard(
                  title: "Membersihkan Properti Rumah",
                  description: "Saya membutuhkan pekerja kebersihan untuk membersihkan dalam rumah saya...",
                  time: "10.00 WIB",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          DateItem(day: "6", weekday: "Kamis"),
          DateItem(day: "7", weekday: "Jumat"),
          DateItem(day: "8", weekday: "Sabtu", isSelected: true),
          DateItem(day: "9", weekday: "Minggu"),
          DateItem(day: "10", weekday: "Senin"),
        ],
      ),
    );
  }
}

class DateItem extends StatelessWidget {
  final String day;
  final String weekday;
  final bool isSelected;

  const DateItem({required this.day, required this.weekday, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(weekday, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class StatusFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterButton(label: "Semua"),
        FilterButton(label: "Tersedia", isSelected: true),
        FilterButton(label: "Dalam Proses"),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const FilterButton({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.purple.shade100 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  const JobCard({required this.title, required this.description, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(description, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                Chip(label: Text("Tersedia"), backgroundColor: Colors.purple.shade100),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Obrolan"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: "Beri Kerja"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Aktivitas"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}
