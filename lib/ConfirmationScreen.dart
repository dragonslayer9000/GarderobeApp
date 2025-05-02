import 'package:flutter/material.dart';

class Confirmationscreen extends StatelessWidget {
  const Confirmationscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Confirmation',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}