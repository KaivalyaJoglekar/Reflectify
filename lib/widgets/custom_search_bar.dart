import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark background for the search bar
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search your lesson...',
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          border: InputBorder.none, // Remove default border styling
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
