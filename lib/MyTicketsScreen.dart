import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils.dart';
import 'package:intl/intl.dart'; // for formatting dates

const baseUrl = 'http://192.168.0.17:8090';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  List<dynamic> tickets = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    final id = (await getUserId()).trim();


    print('🔍 Loading tickets for user ID: $userId');

    final url = Uri.parse('$baseUrl/api/collections/tickets/records');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userId = id;
        tickets = data['items'];
        isLoading = false;
      });
    } else {
      print('Failed to load tickets: ${response.statusCode}');
      print('Response: ${response.body}');
      setState(() {
        userId = id;
        isLoading = false;
      });
    }
  }

String formatDateTime(String isoString) {
  if (isoString.isEmpty) return 'Unknown date';
  final utcTime = DateTime.parse(isoString).toUtc();
  final danishTime = utcTime.toLocal(); // Converts to local time (Copenhagen if device is set to Denmark)

  return DateFormat('dd/MM/yyyy - HH:mm', 'da_DK').format(danishTime);
}

String calculateCountdown(String isoString) {
  final created = DateTime.tryParse(isoString);
  if (created == null) return 'Invalid';

  final expiry = created.add(const Duration(days: 30));
  final remaining = expiry.difference(DateTime.now());

  if (remaining.isNegative) {
    return 'Expired';
  } else {
    return '${remaining.inDays} days left';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? Center(
                  child: Text('No tickets found for user ID:\n${userId ?? "unknown"}'),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    final createdAt = ticket['created'];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('Ticket #${ticket['number']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${formatDateTime(createdAt)}'),
                            Text('Pickup deadline: ${calculateCountdown(createdAt)}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

