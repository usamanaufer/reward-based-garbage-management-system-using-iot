import 'package:flutter/material.dart';
import 'package:garbage_app_create/screens/home_screen.dart';
import 'package:garbage_app_create/screens/profile.dart';
import 'package:garbage_app_create/screens/settings.dart';
import 'package:garbage_app_create/screens/voucher.dart';

class bottom extends StatefulWidget {
  @override
  _bottomState createState() => _bottomState();
}

int currentIndex = 0;
final screens = [
  HomeScreen(),
  Voucher(),
  SettingsPage(),
];

class _bottomState extends State<bottom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.green.shade800,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_shortcut),
            label: 'Vouchers',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profle',
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
