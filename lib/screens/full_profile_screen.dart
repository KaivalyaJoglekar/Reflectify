import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:reflectify/models/focus_session_model.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/custom_toast.dart';
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
          bottom: false, // Handle bottom padding manually
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).padding.bottom + 24, // Add padding for Android nav buttons
            ),
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 32),
              _buildStatsCard(context),
              const SizedBox(height: 24),
              _buildAnalyticsCard(context),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
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
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.2),
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
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.4),
          ),
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
    // Get the start of the week (Monday)
    final today = _selectedDate;
    final weekday = today.weekday; // 1 = Monday, 7 = Sunday
    final startOfWeek = today.subtract(Duration(days: weekday - 1));

    final spots = <FlSpot>[];
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dayTasks = widget.tasks.where(
        (task) =>
            task.date.year == date.year &&
            task.date.month == date.month &&
            task.date.day == date.day &&
            task.isCompleted,
      );
      spots.add(FlSpot(i.toDouble(), dayTasks.length.toDouble()));
    }
    return spots;
  }

  DateTime _getStartOfWeek() {
    final weekday = _selectedDate.weekday; // 1 = Monday, 7 = Sunday
    return _selectedDate.subtract(Duration(days: weekday - 1));
  }

  DateTime _getEndOfWeek() {
    final startOfWeek = _getStartOfWeek();
    return startOfWeek.add(const Duration(days: 6));
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
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
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
                      color: Colors.white.withValues(alpha: 0.3),
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
                            ? '${DateFormat('MMM d').format(_getStartOfWeek())} - ${DateFormat('MMM d').format(_getEndOfWeek())}'
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
                        color: Colors.white.withValues(alpha: 0.1),
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
                          if (value.toInt() >= 0 && value.toInt() < 7) {
                            final date = _getStartOfWeek().add(
                              Duration(days: value.toInt()),
                            );
                            final dayLabels = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];
                            final dayLabel = dayLabels[date.weekday - 1];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                dayLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.6),
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
                              color: Colors.white.withValues(alpha: 0.6),
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
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.2),
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
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
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
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
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
              color: color.withValues(alpha: 0.2),
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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return _buildGlassCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF92A2A).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.logout, color: Color(0xFFF92A2A), size: 20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Color(0xFFF92A2A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFF92A2A),
          size: 16,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              backgroundColor: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Close the dialog first
                    Navigator.pop(dialogContext);

                    try {
                      // Sign out from Firebase
                      await fb_auth.FirebaseAuth.instance.signOut();

                      // Show success toast (use the original context, not dialog context)
                      if (!context.mounted) return;
                      CustomToast.show(
                        context,
                        message: 'Logged out successfully. See you soon!',
                        icon: Icons.logout,
                        iconColor: Colors.green,
                      );

                      // Small delay for toast to show
                      await Future.delayed(const Duration(milliseconds: 800));

                      // Navigate to login screen, clearing all routes
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    } catch (e) {
                      // Show error toast
                      if (!context.mounted) return;
                      CustomToast.show(
                        context,
                        message: 'Logout failed. Please try again',
                        icon: Icons.error_outline,
                        iconColor: Colors.red,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF92A2A),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
