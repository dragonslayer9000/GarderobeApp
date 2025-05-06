import 'package:flutter/material.dart';
import 'package:garderobe_app/PickUpScreen.dart';
import 'ScanScreen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFB75E), Color(0xFFED8F03)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      width: double.infinity,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'lib/assets/logo.png',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(height: 70),
            const Text(
              'Welcome to Wardrobe!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              ),
            ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanScreen()),
                );
              },
              child: const Text('Hand in jacket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              ),
            ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PickUpScreen()),
                );
              },
              child: const Text('Pick up jacket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
