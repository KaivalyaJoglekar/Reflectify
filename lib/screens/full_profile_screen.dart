import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/utils/streak_calculator.dart';

class FullProfileScreen extends StatelessWidget {
  final User user;

  const FullProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 32),
              _buildStreakCard(context),
              const SizedBox(height: 24),
              _buildHeatmapCard(context),
              const SizedBox(height: 24),
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
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(Icons.edit, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '@${user.username}',
          style: const TextStyle(fontSize: 16, color: Colors.white60),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    final currentStreak = StreakCalculator.calculateCurrentStreak();

    return _buildGlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Color(0xFFFF6B35),
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Streak',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentStreak Days',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep it going! 🔥',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapCard(BuildContext context) {
    final streakData = StreakCalculator.generateStreakData();
    final today = DateTime.now();
    final startDate = today.subtract(
      const Duration(days: 90),
    ); // Show last 90 days

    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCustomHeatmap(context, streakData, startDate, today),
          const SizedBox(height: 12),
          _buildHeatmapLegend(context),
        ],
      ),
    );
  }

  Widget _buildCustomHeatmap(
    BuildContext context,
    Map<DateTime, int> data,
    DateTime start,
    DateTime end,
  ) {
    final weeks = (end.difference(start).inDays / 7).ceil();

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weeks,
        itemBuilder: (context, weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (dayIndex) {
                final date = start.add(
                  Duration(days: weekIndex * 7 + dayIndex),
                );
                if (date.isAfter(end)) {
                  return const SizedBox(width: 12, height: 12);
                }
                final key = DateTime(date.year, date.month, date.day);
                final value = data[key] ?? 0;

                return Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(context, value),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Color _getHeatmapColor(BuildContext context, int value) {
    if (value == 0) return Colors.white.withOpacity(0.1);
    if (value == 1) return Theme.of(context).primaryColor.withOpacity(0.2);
    if (value == 2) return Theme.of(context).primaryColor.withOpacity(0.4);
    if (value == 3) return Theme.of(context).primaryColor.withOpacity(0.6);
    if (value == 4) return Theme.of(context).primaryColor.withOpacity(0.8);
    return Theme.of(context).primaryColor;
  }

  Widget _buildHeatmapLegend(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Less',
          style: TextStyle(fontSize: 11, color: Colors.white54),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getHeatmapColor(context, index),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        const Text(
          'More',
          style: TextStyle(fontSize: 11, color: Colors.white54),
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
            const Color(0xFF3B82F6),
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.task_alt_rounded,
            'Tasks Completed',
            '142',
            const Color(0xFF10B981),
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.local_fire_department_rounded,
            'Longest Streak',
            '${StreakCalculator.calculateLongestStreak()} days',
            const Color(0xFFFF6B35),
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.calendar_month_rounded,
            'Member Since',
            'Oct 15, 2025',
            const Color(0xFF8A5DF4),
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
            leading: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF8A5DF4),
            ),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFF10B981),
            ),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFF92A2A)),
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
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: child,
    );
  }
}
