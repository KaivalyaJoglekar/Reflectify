// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:reflectify/models/focus_session_model.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class FullProfileScreen extends StatefulWidget {
  final User user;
  final List<Task> tasks;
  final List<FocusSession> focusSessions;
  final List<JournalEntry> journalEntries;

  const FullProfileScreen({
    super.key,
    required this.user,
    this.tasks = const [],
    this.focusSessions = const [],
    this.journalEntries = const [],
  });

  @override
  State<FullProfileScreen> createState() => _FullProfileScreenState();
}

class _FullProfileScreenState extends State<FullProfileScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showWeekly = true; // true for weekly, false for daily

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
              _buildStatsCard(context),
              const SizedBox(height: 24),
              _buildAnalyticsCard(context),
              const SizedBox(height: 100), // Extra padding for bottom nav
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
                  widget.user.name.isNotEmpty
                      ? widget.user.name[0].toUpperCase()
                      : 'U',
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
          widget.user.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '@${widget.user.username}',
          style: const TextStyle(fontSize: 16, color: Colors.white60),
        ),
        const SizedBox(height: 8),
        Text(
          widget.user.email,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }

  int _calculateLongestStreak() {
    if (widget.tasks.isEmpty) return 0;

    // Get all completed task dates
    final completedDates =
        widget.tasks
            .where((task) => task.isCompleted)
            .map(
              (task) =>
                  DateTime(task.date.year, task.date.month, task.date.day),
            )
            .toSet()
            .toList()
          ..sort();

    if (completedDates.isEmpty) return 0;

    int maxStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < completedDates.length; i++) {
      if (completedDates[i].difference(completedDates[i - 1]).inDays == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  Widget _buildStatsCard(BuildContext context) {
    // Calculate real-time stats
    final totalEntries = widget.journalEntries.length;
    final completedTasks = widget.tasks
        .where((task) => task.isCompleted)
        .length;
    final longestStreak = _calculateLongestStreak();

    // Get Firebase creation date
    final fb_auth.User? firebaseUser =
        fb_auth.FirebaseAuth.instance.currentUser;
    final DateTime? creationTime = firebaseUser?.metadata.creationTime;
    final memberSince = creationTime != null
        ? DateFormat('MMM d, yyyy').format(creationTime)
        : 'Unknown';

    return _buildGlassCard(
      child: Column(
        children: [
          _buildStatRow(
            context,
            Icons.edit_note_rounded,
            'Total Entries',
            '$totalEntries',
            const Color(0xFF3B82F6),
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.task_alt_rounded,
            'Tasks Completed',
            '$completedTasks',
            const Color(0xFF10B981),
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.local_fire_department_rounded,
            'Longest Streak',
            '$longestStreak days',
            const Color(0xFFFF6B35),
          ),
          const Divider(color: Colors.white12),
          _buildStatRow(
            context,
            Icons.calendar_month_rounded,
            'Member Since',
            memberSince,
            const Color(0xFF8A5DF4),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getWeeklyData() {
    final spots = <FlSpot>[];
    for (int i = 6; i >= 0; i--) {
      final date = _selectedDate.subtract(Duration(days: i));
      final dayTasks = widget.tasks.where(
        (task) =>
            task.date.year == date.year &&
            task.date.month == date.month &&
            task.date.day == date.day &&
            task.isCompleted,
      );
      spots.add(FlSpot((6 - i).toDouble(), dayTasks.length.toDouble()));
    }
    return spots;
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    final weeklySpots = _getWeeklyData();
    final selectedDayTasks = widget.tasks.where(
      (task) =>
          task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day,
    );
    final completedToday = selectedDayTasks.where((t) => t.isCompleted).length;
    final totalToday = selectedDayTasks.length;

    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Analytics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _showWeekly
                          ? Icons.calendar_view_week
                          : Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _showWeekly ? 'Weekly' : 'Daily',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Date Navigator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(
                      Duration(days: _showWeekly ? 7 : 1),
                    );
                  });
                },
              ),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _showWeekly
                            ? '${DateFormat('MMM d').format(_selectedDate.subtract(const Duration(days: 6)))} - ${DateFormat('MMM d').format(_selectedDate)}'
                            : DateFormat('MMM d, yyyy').format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed:
                    _selectedDate.isBefore(
                      DateTime.now().subtract(
                        Duration(days: _showWeekly ? 0 : 0),
                      ),
                    )
                    ? () {
                        setState(() {
                          _selectedDate = _selectedDate.add(
                            Duration(days: _showWeekly ? 7 : 1),
                          );
                          if (_selectedDate.isAfter(DateTime.now())) {
                            _selectedDate = DateTime.now();
                          }
                        });
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Weekly Chart
          if (_showWeekly)
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ];
                          if (value.toInt() >= 0 && value.toInt() < 7) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                days[value.toInt()],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY:
                      (weeklySpots
                                  .map((e) => e.y)
                                  .reduce((a, b) => a > b ? a : b) +
                              2)
                          .toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weeklySpots,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Daily Stats
          if (!_showWeekly)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAnalyticItem(
                      'Tasks',
                      '$completedToday/$totalToday',
                      Icons.task_alt,
                      const Color(0xFF10B981),
                    ),
                    _buildAnalyticItem(
                      'Rate',
                      totalToday > 0
                          ? '${(completedToday / totalToday * 100).toStringAsFixed(0)}%'
                          : '0%',
                      Icons.trending_up,
                      const Color(0xFFFF6B35),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (totalToday > 0)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: completedToday / totalToday,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      minHeight: 10,
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 24),
          // Toggle button
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _showWeekly = !_showWeekly;
                });
              },
              icon: Icon(
                _showWeekly ? Icons.calendar_today : Icons.calendar_view_week,
                size: 18,
              ),
              label: Text(_showWeekly ? 'Switch to Daily' : 'Switch to Weekly'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
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

  Widget _buildAnalyticItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
        ),
      ],
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
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
      ),
      child: child,
    );
  }
}
