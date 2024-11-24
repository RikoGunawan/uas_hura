import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test/screens/base_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Mengatur durasi splash screen
    Future.delayed(const Duration(seconds: 3), () {
      // Navigasi ke halaman utama setelah durasi
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BaseScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar logo (jika ada)
            // Image.asset('assets/images/your_image.png'), // Uncomment jika menggunakan gambar
            Text(
            'TAHURA',
            textAlign: TextAlign.center, // Center the text
            style: TextStyle(
              fontSize: 40, // Increased font size
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text for better contrast
              shadows: [
                Shadow(
                  blurRadius: 10.0, // Blur radius of the shadow
                  color: Colors.black54, // Color of the shadow
                  offset: Offset(2.0, 2.0), // Offset of the shadow
                ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            // ),
          ],
        ),
      ),
    );
  }
}