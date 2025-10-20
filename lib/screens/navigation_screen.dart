import 'package:flutter/material.dart';
import 'package:reflectify/screens/add_journal_screen.dart';
import 'package:reflectify/screens/dashboard_screen.dart';
import 'package:reflectify/screens/journal_list_screen.dart';
import 'package:reflectify/screens/profile_screen.dart';
import 'package:reflectify/screens/placeholder_screen.dart'; // Can be used for stats
import '../models/user_model.dart';

class NavigationScreen extends StatefulWidget {
  final User user;
  const NavigationScreen({super.key, required this.user});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      DashboardScreen(user: widget.user),
      const JournalListScreen(),
      const PlaceholderScreen(title: 'Stats'), // Placeholder for Stats Screen
      ProfileScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      // Styling the bottom bar to be dark/transparent and match the image structure
      bottomNavigationBar: BottomAppBar(
        color: Colors.black.withOpacity(
          0.8,
        ), // Dark, slightly opaque background
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(0, Icons.home_filled, 'Home'), // Home icon (filled)
            _buildNavItem(1, Icons.calendar_month, 'Calendar'), // Calendar icon
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(2, Icons.show_chart, 'Chart'), // Chart icon
            _buildNavItem(3, Icons.person, 'Profile'), // Profile icon
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AddJournalScreen(selectedDate: DateTime.now()),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.add, size: 30),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Theme.of(context).primaryColor : Colors.white54;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            // Optional: You can add the label text here if you prefer that style
            // Text(label, style: TextStyle(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
