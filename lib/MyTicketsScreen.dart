import 'package:flutter/material.dart';
import 'package:garderobe_app/PickUpScreen.dart';
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
  final activeTickets = tickets.where((t) => t['status'] == true).toList();
  final inactiveTickets = tickets.where((t) => t['status'] != true).toList();

  return Scaffold(
    appBar: AppBar(title: const Text('My Tickets')),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : tickets.isEmpty
            ? Center(
                child: Text('No tickets found for user ID:\n${userId ?? "unknown"}'),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (activeTickets.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Active Tickets',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ...activeTickets.map((ticket) => buildTicketTile(context, ticket, true)).toList(),

                  if (inactiveTickets.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ...inactiveTickets.map((ticket) => buildTicketTile(context, ticket, false)).toList(),
                ],
              ),
  );
}
Widget buildTicketTile(BuildContext context, Map<String, dynamic> ticket, bool isActive) {
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
          if (!isActive)
            const Text(
              'Picked up',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
        ],
      ),
      enabled: isActive,
      onTap: isActive
          ? () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pick up jacket'),
                  content: const Text('Are you sure you want to pick up this jacket?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PickUpScreen(
                      ticketId: ticket['id'],
                      ticketNumber: ticket['number'],
                      createdAt: ticket['created'],
                    ),
                  ),
                );
              }
            }
          : null,
      ),
    );
  }
}


