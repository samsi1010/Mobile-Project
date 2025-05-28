import 'package:flutter/material.dart';

class FormValidasiPage extends StatefulWidget {
  const FormValidasiPage({super.key});

  @override
  State<FormValidasiPage> createState() => _FormValidasiPageState();
}

class _FormValidasiPageState extends State<FormValidasiPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                const Text(
                  'Selamat!\nAnda telah mendaftar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Lamaran anda telah terkirim.\nTunggu kabar dari pemberi kerja ya!!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: 160,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 145, 248), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Beranda'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
