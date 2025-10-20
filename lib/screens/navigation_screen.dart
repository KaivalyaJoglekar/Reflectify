import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/dashboard_screen.dart';
import 'package:reflectify/screens/schedule_screen.dart';
import 'package:reflectify/screens/placeholder_screen.dart';
import 'package:reflectify/widgets/app_background.dart';

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
      const ScheduleScreen(),
      const PlaceholderScreen(title: 'Stats'),
      const PlaceholderScreen(title: 'Notifications'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent, // Let the AppBackground show through
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: _buildTransparentBottomBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildTransparentBottomBar() {
    return Container(
      height: 75,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(0, Icons.home_rounded),
              _buildNavItem(1, Icons.bar_chart_rounded),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(2, Icons.pie_chart_outline_rounded),
              _buildNavItem(3, Icons.notifications_none_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.white54,
        size: 28,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}