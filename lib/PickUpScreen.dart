import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const baseUrl = 'http://192.168.0.17:8090';

class PickUpScreen extends StatelessWidget {
  final String ticketId;
  final int ticketNumber;
  final String createdAt;

  const PickUpScreen({
    super.key,
    required this.ticketId,
    required this.ticketNumber,
    required this.createdAt,
  });

  Future<bool> markTicketAsPickedUp() async {
    final url = Uri.parse('$baseUrl/api/collections/tickets/records/$ticketId');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': false}),
    );

    return response.statusCode == 200;
  }

  String formatDate(String iso) {
    final dt = DateTime.parse(iso).toLocal();
    return DateFormat('d. MMMM y - HH:mm', 'da_DK').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket #$ticketNumber')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Created: ${formatDate(createdAt)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            SwipeToPickUp(
              ticketNumber: ticketNumber,
              onSwipeConfirmed: markTicketAsPickedUp,
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeToPickUp extends StatefulWidget {
  final Future<bool> Function() onSwipeConfirmed;
  final int ticketNumber;

  const SwipeToPickUp({
    super.key,
    required this.onSwipeConfirmed,
    required this.ticketNumber,
  });

  @override
  State<SwipeToPickUp> createState() => _SwipeToPickUpState();
}

class _SwipeToPickUpState extends State<SwipeToPickUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _swiped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0), // slight right-left movement
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleSwipe(BuildContext context, DragEndDetails details) async {
    if (_swiped) return; // prevent multiple swipes

    if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
      setState(() => _swiped = true);
      final success = await widget.onSwipeConfirmed();
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket #${widget.ticketNumber} marked as picked up')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update ticket')),
        );
        setState(() => _swiped = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => handleSwipe(context, details),
      child: Container(
        width: 320,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: _swiped
            ? const Icon(Icons.check, color: Colors.white, size: 30)
            : SlideTransition(
                position: _animation,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Swipe to pick up ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
      ),
    );
  }
}
