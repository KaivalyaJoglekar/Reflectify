import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:reflectify/models/daily_summary_model.dart';
import 'package:reflectify/models/focus_session_model.dart';
import 'package:intl/intl.dart';

class DailySummaryScreen extends StatefulWidget {
  final List<Task> tasks;
  final List<FocusSession> focusSessions;
  final DateTime? selectedDate;

  const DailySummaryScreen({
    super.key,
    required this.tasks,
    required this.focusSessions,
    this.selectedDate,
  });

  @override
  State<DailySummaryScreen> createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends State<DailySummaryScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime(2025, 10, 15);
  }

  DailySummary _calculateDailySummary(DateTime date) {
    final dayTasks = widget.tasks.where(
      (task) =>
          task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day,
    );

    final completedTasks = dayTasks.where((t) => t.isCompleted).length;
    final totalTasks = dayTasks.length;

    final daySessions = widget.focusSessions.where(
      (session) =>
          session.startTime.year == date.year &&
          session.startTime.month == date.month &&
          session.startTime.day == date.day,
    );

    final focusMinutes = daySessions.fold<int>(
      0,
      (sum, session) => sum + session.actualMinutes,
    );

    return DailySummary(
      date: date,
      tasksCompleted: completedTasks,
      totalTasks: totalTasks,
      focusMinutes: focusMinutes,
    );
  }

  List<DailySummary> _getWeeklySummaries() {
    final summaries = <DailySummary>[];
    for (int i = 6; i >= 0; i--) {
      final date = _selectedDate.subtract(Duration(days: i));
      summaries.add(_calculateDailySummary(date));
    }
    return summaries;
  }

  @override
  Widget build(BuildContext context) {
    final summary = _calculateDailySummary(_selectedDate);
    final weeklySummaries = _getWeeklySummaries();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildDateSelector(),
              const SizedBox(height: 24),
              _buildDailySummaryCard(summary),
              const SizedBox(height: 24),
              _buildWeeklyChart(weeklySummaries),
              const SizedBox(height: 24),
              _buildProductivityInsights(weeklySummaries),
              const SizedBox(height: 24),
              _buildStreakCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Summary',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Track your productivity',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.insights),
          onPressed: () => _showDetailedAnalytics(),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.subtract(const Duration(days: 1));
            });
          },
        ),
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            if (_selectedDate.isBefore(DateTime.now())) {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildDailySummaryCard(DailySummary summary) {
    final completionRate = summary.completionRate;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.3),
            Theme.of(context).primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'Tasks',
                '${summary.tasksCompleted}/${summary.totalTasks}',
                Icons.task_alt,
                Colors.green,
              ),
              _buildSummaryItem(
                'Focus',
                '${summary.focusMinutes}m',
                Icons.timer,
                Colors.blue,
              ),
              _buildSummaryItem(
                'Rate',
                '${completionRate.toStringAsFixed(0)}%',
                Icons.trending_up,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate / 100,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(List<DailySummary> summaries) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Performance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: summaries
                    .map((s) => s.totalTasks.toDouble())
                    .reduce((a, b) => a > b ? a : b)
                    .ceilToDouble(),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < summaries.length) {
                          return Text(
                            DateFormat(
                              'E',
                            ).format(summaries[index].date).substring(0, 1),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: summaries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final summary = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: summary.totalTasks.toDouble(),
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: summary.tasksCompleted.toDouble(),
                        color: Theme.of(context).primaryColor,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductivityInsights(List<DailySummary> summaries) {
    final totalCompleted = summaries.fold<int>(
      0,
      (sum, s) => sum + s.tasksCompleted,
    );
    final totalTasks = summaries.fold<int>(0, (sum, s) => sum + s.totalTasks);
    final totalFocus = summaries.fold<int>(0, (sum, s) => sum + s.focusMinutes);
    final avgCompletion = totalTasks > 0
        ? (totalCompleted / totalTasks * 100)
        : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInsightRow(
            'Tasks Completed',
            '$totalCompleted',
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildInsightRow(
            'Average Completion',
            '${avgCompletion.toStringAsFixed(1)}%',
            Icons.trending_up,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildInsightRow(
            'Total Focus Time',
            '${(totalFocus / 60).toStringAsFixed(1)}h',
            Icons.timer,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFF4A261)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep it up!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You\'re building great habits',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          'Detailed Analytics',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Coming soon: Monthly trends, category breakdowns, and productivity patterns.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
