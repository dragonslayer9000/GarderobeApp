import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'MyTicketsScreen.dart';

class PaymentScreen extends StatelessWidget {
  final String userId;
  final String garderobe;

  const PaymentScreen({
    super.key,
    required this.userId,
    required this.garderobe,
  });

  Future<void> createTicket(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:8090/api/collections/tickets/records');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'garderobe': garderobe,
        'status': true,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }


Future<int?> findLowestAvailableNumber() async {
  final url = Uri.parse('http://127.0.0.1:8090/api/collections/tickets/records?perPage=200');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<int> usedNumbers = [];

    for (var item in data['items']) {
      // Only include active tickets
      if (item['status'] == true && item['number'] != null) {
        usedNumbers.add(item['number']);
      }
    }

    // Find lowest unused number from 1 to 200
    for (int i = 1; i <= 200; i++) {
      if (!usedNumbers.contains(i)) {
        return i;
      }
    }
    return null; // All taken
  } else {
    print('Failed to fetch records');
    return null;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pay 30 kr for coat check-in',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => createTicket(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      ),
    );
  }
}
