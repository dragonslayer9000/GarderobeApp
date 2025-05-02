import 'package:flutter/material.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'My Tickets Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
