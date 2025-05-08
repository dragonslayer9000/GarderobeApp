import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'MyTicketsScreen.dart';
import 'NumberConfirmationScreen.dart';

const baseUrl = 'http://192.168.0.17:8090';

class PaymentScreen extends StatelessWidget {
  final String userId;
  final String garderobe;

  const PaymentScreen({
    super.key,
    required this.userId,
    required this.garderobe,
  });

  Future<int?> createTicket(BuildContext context, String userId, String garderobe) async {
    final lowestNumber = await findLowestAvailableNumber();

    print('Lowest number available: $lowestNumber');


  if (lowestNumber == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All cloakroom numbers are in use.')),
    );
    return null;
  }

    final url = Uri.parse('$baseUrl/api/collections/tickets/records');
  final body = {
    'user_id': userId,
    'garderobe': garderobe,
    'status': true,
    'number': lowestNumber,
  };

  // Add these prints for debugging:
  print('Trying to POST new ticket with:');
  print('user_id: $userId, garderobe: $garderobe, number: $lowestNumber');
  print('POST url: $url');
  print('Payload: ${jsonEncode(body)}');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  // Also print response for debugging:
  print('Response code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    return lowestNumber;
  } else {
    print('Failed to create ticket');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to create ticket.')),
    );
    return null;
  }
}


Future<int?> findLowestAvailableNumber() async {
  final url = Uri.parse('$baseUrl/api/collections/tickets/records?perPage=200');
  print('Fetching used ticket numbers from $url');

  final response = await http.get(url);
  print('GET response status: ${response.statusCode}');
  print('GET response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<int> usedNumbers = [];

    for (var item in data['items']) {
      print('Ticket record: $item');
      // Only include active tickets
      if (item['status'] == true && item['number'] != null) {
        usedNumbers.add(item['number']);
      }
    }

    // Find lowest unused number from 1 to 200
    for (int i = 1; i <= 200; i++) {
      if (!usedNumbers.contains(i)) {
        print('Found lowest available number: $i');
        return i;
      }
    }
    print('All numbers are used.');
    return null; // All taken
  } else {
    print('Failed to fetch records: ${response.statusCode}');
    print('Response body: ${response.body}');
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
              onPressed: () async {
                final ticketNumber = await createTicket(context, userId, garderobe);
                print('Okay button pressed!');
                if (ticketNumber != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NumberConfirmationScreen(ticketNumber: ticketNumber),
                    ),
                  );
                } else {
                  // Optionally show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create ticket')),
                  );
                }
              },
              child: const Text('Okay')
            ),
          ],
        ),
      ),
    );
  }
}
