import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:reflectify/widgets/glass_card.dart'; // Import new widget

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Use the standard AppBackground
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 32),
              _buildStatsCard(context),
              const SizedBox(height: 24),
              _buildActionsCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            user.name.isNotEmpty ? user.name[0] : 'U',
            style: const TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          '@${user.username}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    // Use the new GlassCard widget
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildStatRow(
            context,
            Icons.edit_note_rounded,
            'Total Entries',
            '87',
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.local_fire_department_rounded,
            'Longest Streak',
            '23 days',
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.cake_rounded,
            'Member Since',
            'Oct 2025',
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    // Use the new GlassCard widget
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFF92A2A)),
            title: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFF92A2A)),
            ),
            onTap: () async {
              await fb_auth.FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // The local _buildGlassCard method is no longer needed
  // and can be deleted.
}