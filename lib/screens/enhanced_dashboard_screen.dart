import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:reflectify/models/project_model.dart';
import 'package:reflectify/utils/streak_calculator.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  final User user;
  final List<Task> tasks;
  final List<Project> projects;
  final Function(Task) onTaskComplete;
  final VoidCallback onAddTask;
  final VoidCallback onViewCalendar;
  final VoidCallback onViewProjects;

  const EnhancedDashboardScreen({
    super.key,
    required this.user,
    this.tasks = const [],
    this.projects = const [],
    required this.onTaskComplete,
    required this.onAddTask,
    required this.onViewCalendar,
    required this.onViewProjects,
  });

  @override
  State<EnhancedDashboardScreen> createState() =>
      _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayTasks = _getTodayTasks();
    final priorities = _getTopPriorities();
    final upcomingDeadlines = _getUpcomingDeadlines();

    return Stack(
      children: [
        // Gradient orb
        Positioned(
          top: -120,
          left: -100,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
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
      ],
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
    final now = DateTime.now();
    final tasksWithDeadlines = widget.tasks
        .where((task) => task.deadline != null && !task.isCompleted)
        .toList();
    tasksWithDeadlines.sort((a, b) => a.deadline!.compareTo(b.deadline!));
    return tasksWithDeadlines
        .where((task) => task.deadline!.isAfter(now))
        .take(5)
        .toList();
  }

  Widget _buildAppBar(BuildContext context) {
    final int currentStreak = StreakCalculator.calculateCurrentStreak();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3',
              ),
            ),
            const SizedBox(width: 16),
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
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.settings, size: 28, color: Colors.white),
              onPressed: () {},
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
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            DateFormat('EEEE, MMMM d').format(today),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${_getTodayTasks().where((t) => !t.isCompleted).length} tasks remaining',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
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
                'Add Task',
                Icons.add_task,
                const Color(0xFF8A5DF4),
                widget.onAddTask,
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
                'Projects',
                Icons.folder,
                const Color(0xFF4ECDC4),
                widget.onViewProjects,
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: priorityColor.withOpacity(0.4), width: 1.5),
      ),
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
                        color: priorityColor.withOpacity(0.2),
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
                        color: Colors.white.withOpacity(0.5),
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
          _buildEmptyState('No upcoming deadlines', Icons.event_available)
        else
          ...deadlines.map((task) => _buildDeadlineCard(task)),
      ],
    );
  }

  Widget _buildDeadlineCard(Task task) {
    final daysUntil = task.deadline!.difference(DateTime.now()).inDays;
    final isUrgent = daysUntil <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isUrgent ? Colors.red : Theme.of(context).primaryColor)
              .withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isUrgent ? Icons.warning_amber : Icons.event,
            color: isUrgent ? Colors.red : Colors.white70,
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
                  DateFormat('MMM d, yyyy').format(task.deadline!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (isUrgent ? Colors.red : Colors.blue).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${daysUntil}d',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isUrgent ? Colors.red : Colors.blue,
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
            'Today\'s Progress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.1),
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
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
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
