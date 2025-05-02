import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'MyTicketsScreen.dart';
import 'ScanScreen.dart';
import 'ConfirmationScreen.dart';


void main() {
  runApp(const GarderobeApp());
}

class GarderobeApp extends StatelessWidget {
  const GarderobeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garderobe App',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const MainNavigation(),

    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const MyTicketsScreen(),
    const ScanScreen(),
    const Confirmationscreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Selected icon and label color
        unselectedItemColor: Colors.black54, // Unselected icon color
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

