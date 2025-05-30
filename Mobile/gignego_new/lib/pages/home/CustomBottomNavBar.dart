import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home/statuskerja.dart';
import 'package:flutter_application/pages/home/home_page.dart';
import 'package:flutter_application/pages/profil/profil.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final String? currentUserEmail;

  const CustomBottomNavBar({required this.currentIndex, this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              "assets/home.png",
              0,
              currentIndex,
              () {
                if (currentIndex != 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              "assets/obrolan.png",
              1,
              currentIndex,
              () {
                // Navigasi halaman chat bisa ditambahkan di sini
              },
            ),
            _buildNavItem(
              context,
              "assets/aktivitas.png",
              2,
              currentIndex,
              () {
                if (currentUserEmail != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatusKerjaPage(userEmail: currentUserEmail!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User belum login')),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              "assets/profil.png",
              3,
              currentIndex,
              () {
                if (currentIndex != 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String iconPath, int index,
      int currentIndex, VoidCallback onPressed) {
    final bool isActive = currentIndex == index;

    return IconButton(
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isActive ? Color(0xFF9E61EB) : Colors.black,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          iconPath,
          width: 35,
          height: 35,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
