import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'MyTicketsScreen.dart';

final GlobalKey<_MainNavigationState> navKey = GlobalKey<_MainNavigationState>();

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
      home: MainNavigation(key: navKey), // <-- use the global key here
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyTicketsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // This allows external screens to switch tabs
  void switchTab(int index) {
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
        selectedItemColor: Colors.black,
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
