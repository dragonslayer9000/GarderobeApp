import 'package:flutter/material.dart';
import 'main.dart';

class PickUpScreen extends StatelessWidget {
  const PickUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Pick Up Jacket',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Optional: mark Home as selected
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst); // Go to Home
          } else if (index == 1) {
            Navigator.popUntil(context, (route) => route.isFirst); // Reset stack
            navKey.currentState?.switchTab(1); // Switch to My Tickets tab
         }
        },
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'My tickets',
          ),
        ],
      ),
    );
  }
}

