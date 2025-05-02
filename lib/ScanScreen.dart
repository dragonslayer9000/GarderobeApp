import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text('Scan screen content goes here'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Optional: mark Home as selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Go back to Home
          } else if (index == 1) {
            // Navigate to My Tickets screen
            Navigator.popUntil(context, (route) => route.isFirst);
            // You could then switch tab externally if needed
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





