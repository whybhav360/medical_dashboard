import 'package:flutter/material.dart';
import 'package:medical_dashboard/pages/home.dart';
import 'package:medical_dashboard/pages/profile.dart';
import 'package:medical_dashboard/pages/reports.dart';
import 'package:medical_dashboard/pages/settings.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 2;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SettingsPage(),
    ReportsPage(),
    SettingsPage(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.lightBlueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.videogame_asset_outlined,
              ),
              label: 'Controller'),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined), label: 'Reports'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
