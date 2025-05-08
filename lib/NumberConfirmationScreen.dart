import 'package:flutter/material.dart';
import 'main.dart';

class NumberConfirmationScreen extends StatelessWidget {
  final int ticketNumber;

  const NumberConfirmationScreen({super.key, required this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Confirmed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your coat has been checked in!',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            Text(
              'Ticket Number: #$ticketNumber',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                navKey.currentState?.switchTab(1); // Go to My Tickets
              },
              child: const Text('Go to My Tickets'),
            ),
          ],
        ),
      ),
    );
  }
}
