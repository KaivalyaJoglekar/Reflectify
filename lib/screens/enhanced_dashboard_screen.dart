import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:reflectify/models/project_model.dart';
import 'package:reflectify/utils/streak_calculator.dart';
import 'package:reflectify/widgets/app_background.dart'; // Import
import 'package:reflectify/widgets/glass_card.dart'; // Import

class EnhancedDashboardScreen extends StatefulWidget {
  final User user;
  final List<Task> tasks;
  final List<Project> projects;
  final Function(Task) onTaskComplete;
  final VoidCallback onAddTask;
  final VoidCallback onViewCalendar;
  final VoidCallback onFocusMode;
  final VoidCallback onProfileTap;
  final VoidCallback onAddJournal; // NEW: Journal callback

  const EnhancedDashboardScreen({
    super.key,
    required this.user,
    this.tasks = const [],
    this.projects = const [],
    required this.onTaskComplete,
    required this.onAddTask,
    required this.onViewCalendar,
    required this.onFocusMode,
    required this.onProfileTap,
    required this.onAddJournal,
  });

  @override
  State<EnhancedDashboardScreen> createState() =>
      _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen> {
  void _showTodayTasksDialog(List<Task> todayTasks) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '${todayTasks.length} total',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Task List
              Flexible(
                child: todayTasks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tasks for today',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: todayTasks.length,
                        itemBuilder: (context, index) {
                          final task = todayTasks[index];
                          return _buildTaskDialogCard(task);
                        },
                      ),
              ),
              // Close Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskDialogCard(Task task) {
    final categoryColor = _getCategoryColor(task.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.isCompleted
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted
              ? Colors.green.withValues(alpha: 0.5)
              : categoryColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.onTaskComplete(task);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted
                          ? Colors.green
                          : Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    color: task.isCompleted ? Colors.green : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Task Title
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Task Details
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Time Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      task.time,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: categoryColor,
                  ),
                ),
              ),
              // Priority Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPriorityColor(
                    task.priority,
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getPriorityLabel(task.priority),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getPriorityColor(task.priority),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return const Color(0xFF6366F1);
      case 'personal':
        return const Color(0xFF8B5CF6);
      case 'health':
        return const Color(0xFF10B981);
      case 'education':
        return const Color(0xFFF59E0B);
      case 'finance':
        return const Color(0xFF3B82F6);
      case 'social':
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayTasks = _getTodayTasks();
    final priorities = _getTopPriorities();
    final upcomingDeadlines = _getUpcomingDeadlines();

    // Replace Stack with AppBackground
    return AppBackground(
      child: SafeArea(
        bottom: false, // Handle bottom padding manually
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).padding.bottom +
                120, // Dynamic padding for navbar + nav buttons
          ),
          children: [
            _buildAppBar(context),
            const SizedBox(height: 24),
            _buildTodayHeader(today),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildTopPriorities(priorities),
            const SizedBox(height: 24),
            _buildUpcomingDeadlines(upcomingDeadlines),
            const SizedBox(height: 24),
            _buildProgressOverview(todayTasks),
          ],
        ),
      ),
    );
  }

  List<Task> _getTodayTasks() {
    final today = DateTime.now();
    return widget.tasks
        .where(
          (task) =>
              task.date.year == today.year &&
              task.date.month == today.month &&
              task.date.day == today.day,
        )
        .toList();
  }

  List<Task> _getTopPriorities() {
    final incompleteTasks = widget.tasks
        .where((task) => !task.isCompleted)
        .toList();
    incompleteTasks.sort((a, b) => a.priority.compareTo(b.priority));
    return incompleteTasks.take(3).toList();
  }

  List<Task> _getUpcomingDeadlines() {
    return widget.tasks.where((task) => !task.isCompleted).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority))
      ..take(5);
  }

  Widget _buildAppBar(BuildContext context) {
    final int currentStreak = StreakCalculator.calculateCurrentStreak();
    final String initial = widget.user.name.isNotEmpty
        ? widget.user.name[0].toUpperCase()
        : 'U';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: widget.onProfileTap,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  widget.user.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(letterSpacing: 1.1),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Color(0xFFFF6B35),
              size: 24,
            ),
            const SizedBox(width: 4),
            Text(
              '$currentStreak',
              style: const TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildTodayHeader(DateTime today) {
    final todayTasks = _getTodayTasks();
    final remainingTasks = todayTasks.where((t) => !t.isCompleted).length;

    // Replace Container with GlassCard
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d').format(today),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$remainingTasks tasks remaining',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showTodayTasksDialog(todayTasks),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                  width: 2,
                ),
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  '${todayTasks.length}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Journal',
                Icons.menu_book,
                const Color(0xFF8A5DF4),
                widget.onAddJournal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Calendar',
                Icons.calendar_today,
                const Color(0xFFD62F6D),
                widget.onViewCalendar,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Focus',
                Icons.psychology,
                const Color(0xFF4CAF50),
                widget.onFocusMode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    // This is already a glass-like card, so we can wrap it in GlassCard
    // for the blur effect, but with custom styling.
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: color.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // We remove the outer container's color and border,
          // as GlassCard now handles it.
          // We keep the inner color from the original design.
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopPriorities(List<Task> priorities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top 3 Priorities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.priority_high, color: Colors.orange[300]),
          ],
        ),
        const SizedBox(height: 12),
        if (priorities.isEmpty)
          _buildEmptyState('No priorities set', Icons.star_outline)
        else
          ...priorities.map((task) => _buildPriorityTaskCard(task)),
      ],
    );
  }

  Widget _buildPriorityTaskCard(Task task) {
    final priorityColor = _getPriorityColor(task.priority);
    final priorityLabel = _getPriorityLabel(task.priority);

    // Replace Container with GlassCard
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: priorityColor.withValues(alpha: 0.5),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (val) => widget.onTaskComplete(task),
            activeColor: priorityColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priorityLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadlines(List<Task> deadlines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Deadlines',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (deadlines.isEmpty)
          _buildEmptyState('No pending tasks', Icons.event_available)
        else
          ...deadlines.map((task) => _buildDeadlineCard(task)),
      ],
    );
  }

  Widget _buildDeadlineCard(Task task) {
    final isHighPriority = task.priority == 1;
    final color = isHighPriority ? Colors.red : Theme.of(context).primaryColor;

    // Calculate days until deadline
    int? daysUntil;
    bool isOverdue = false;
    if (task.deadline != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final deadlineDate = DateTime(
        task.deadline!.year,
        task.deadline!.month,
        task.deadline!.day,
      );
      daysUntil = deadlineDate.difference(today).inDays;
      isOverdue = daysUntil < 0;
    }

    // Replace Container with GlassCard
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: color.withValues(alpha: 0.5),
      child: Row(
        children: [
          Icon(
            isHighPriority ? Icons.warning_amber : Icons.event,
            color: isHighPriority ? Colors.red : Colors.white70,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.deadline != null
                      ? 'Due: ${DateFormat('MMM d, yyyy').format(task.deadline!)}'
                      : DateFormat('MMM d, yyyy').format(task.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          if (daysUntil != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isOverdue
                    ? Colors.red.withValues(alpha: 0.2)
                    : daysUntil <= 3
                    ? Colors.orange.withValues(alpha: 0.2)
                    : Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOverdue
                      ? Colors.red.withValues(alpha: 0.5)
                      : daysUntil <= 3
                      ? Colors.orange.withValues(alpha: 0.5)
                      : Colors.blue.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOverdue
                        ? Icons.error
                        : daysUntil <= 3
                        ? Icons.timer
                        : Icons.calendar_today,
                    size: 14,
                    color: isOverdue
                        ? Colors.red
                        : daysUntil <= 3
                        ? Colors.orange
                        : Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOverdue
                        ? '${daysUntil.abs()}d ago'
                        : daysUntil == 0
                        ? 'Today'
                        : daysUntil == 1
                        ? 'Tomorrow'
                        : '${daysUntil}d',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isOverdue
                          ? Colors.red
                          : daysUntil <= 3
                          ? Colors.orange
                          : Colors.blue,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isHighPriority ? Colors.red : Colors.blue).withValues(
                    alpha: 0.5,
                  ),
                  width: 1.5,
                ),
              ),
              child: Text(
                task.priority == 1
                    ? 'HIGH'
                    : task.priority == 2
                    ? 'MED'
                    : 'LOW',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isHighPriority ? Colors.red : Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(List<Task> todayTasks) {
    final completed = todayTasks.where((t) => t.isCompleted).length;
    final total = todayTasks.length;
    final progress = total > 0 ? completed / total : 0.0;

    // Replace Container with GlassCard
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Progress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$completed of $total tasks completed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    // Replace Container with GlassCard
    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 16,
      borderColor: Colors.white.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.white.withValues(alpha: 0.3)),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'HIGH';
      case 2:
        return 'MEDIUM';
      case 3:
        return 'LOW';
      default:
        return 'NONE';
    }
  }
}
