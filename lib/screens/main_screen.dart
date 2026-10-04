import 'package:flutter/material.dart';
import 'package:taskly/screens/home_screen.dart';
import '../widgets/custom_glass_nav_bar.dart';
import '../widgets/nav_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: HomeScreen()),
    Center(child: Text('Tasks Page')),
    Center(child: Text('Progress Page')),
    Center(child: Text('Settings Page')),
  ];

  final List<NavItem> _items = const [
    NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.assignment_turned_in_outlined, activeIcon: Icons.assignment_turned_in, label: 'Tasks'),
    NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Progress'),
    NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody removed — no longer needed
      body: Stack(
        children: [
          // Screens fill the ENTIRE screen, including behind the bar
          IndexedStack(index: _selectedIndex, children: _pages),

          // The glass bar floats on top of them
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomGlassNavBar(
              items: _items,
              selectedIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}