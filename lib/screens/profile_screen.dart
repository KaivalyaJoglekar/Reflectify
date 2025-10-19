import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/app_background.dart';

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
    return _buildGlassCard(
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
    return _buildGlassCard(
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
            leading: Icon(Icons.logout, color: const Color(0xFFF92A2A)),
            title: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFF92A2A)),
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
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

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}
