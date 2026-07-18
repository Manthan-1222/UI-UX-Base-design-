import 'package:flutter/material.dart';
import '../widgets/pill_nav_bar.dart';

import 'M4 - product_screen.dart';
import 'M5 - customer_screen.dart';
import 'M14 - Setting.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Scaffold(body: Center(child: Text("Home Dashboard View", style: TextStyle(fontSize: 20)))),
    const ProductScreen(), // Note: Assuming this was what HTML meant by Orders, but let's use it here
    const Scaffold(body: Center(child: Text("QR Scan View", style: TextStyle(fontSize: 20)))),
    const CustomerScreen(), // Let's use Customer screen for "Card" or we can rearrange
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The main content area
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          
          // Floating Pill Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Distance from bottom
            child: PillBottomNavBar(
              activeIndex: _currentIndex,
              onTabSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
