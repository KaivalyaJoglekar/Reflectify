// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reflectify/providers/theme_provider.dart';

class EnhancedCalendarScreen extends ConsumerStatefulWidget {
  final List<Task> tasks;
  final Function(DateTime) onDateSelected;
  final Function(Task) onTaskTap;
  final Function(Task)? onTaskEdit;
  final Function(Task)? onTaskDelete;
  final Function(Task)? onTaskToggleComplete;

  const EnhancedCalendarScreen({
    super.key,
    required this.tasks,
    required this.onDateSelected,
    required this.onTaskTap,
    this.onTaskEdit,
    this.onTaskDelete,
    this.onTaskToggleComplete,
  });

  @override
  ConsumerState<EnhancedCalendarScreen> createState() =>
      _EnhancedCalendarScreenState();
}

class _EnhancedCalendarScreenState
    extends ConsumerState<EnhancedCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Task>> _groupTasksByDate() {
    Map<DateTime, List<Task>> grouped = {};
    for (var task in widget.tasks) {
      final date = DateTime(task.date.year, task.date.month, task.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(task);
    }
    return grouped;
  }

  List<Task> _getTasksForDay(DateTime day) {
    final grouped = _groupTasksByDate();
    final normalized = DateTime(day.year, day.month, day.day);
    return grouped[normalized] ?? [];
  }

  void _showTaskOptions(Task task) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Time badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                task.time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              task.category,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getCategoryColor(task.category),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Priority badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                              task.priority,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getPriorityColor(
                                task.priority,
                              ).withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getPriorityIcon(task.priority),
                                size: 12,
                                color: _getPriorityColor(task.priority),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getPriorityLabel(task.priority),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getPriorityColor(task.priority),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 8),
              _buildOptionTile(
                icon: task.isCompleted
                    ? Icons.radio_button_unchecked
                    : Icons.check_circle,
                iconColor: Colors.green,
                title: task.isCompleted
                    ? 'Mark as Incomplete'
                    : 'Mark as Complete',
                onTap: () {
                  Navigator.pop(context);
                  if (widget.onTaskToggleComplete != null) {
                    widget.onTaskToggleComplete!(task);
                  }
                },
              ),
              _buildOptionTile(
                icon: Icons.edit_rounded,
                iconColor: Colors.blue,
                title: 'Edit Task',
                onTap: () {
                  Navigator.pop(context);
                  if (widget.onTaskEdit != null) {
                    widget.onTaskEdit!(task);
                  }
                },
              ),
              _buildOptionTile(
                icon: Icons.delete_rounded,
                iconColor: Colors.red,
                title: 'Delete Task',
                onTap: () {
                  Navigator.pop(context);
                  if (widget.onTaskDelete != null) {
                    widget.onTaskDelete!(task);
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildCalendar(),
            const SizedBox(height: 16),
            _buildSelectedDateHeader(),
            const SizedBox(height: 12),
            Expanded(child: _build24HourTimeline()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tasks',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'BebasNeue',
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _calendarFormat == CalendarFormat.month
                      ? Icons.view_week
                      : Icons.calendar_month,
                ),
                onPressed: () {
                  setState(() {
                    _calendarFormat = _calendarFormat == CalendarFormat.month
                        ? CalendarFormat.week
                        : CalendarFormat.month;
                  });
                },
                tooltip: 'Toggle View',
              ),
              IconButton(
                icon: const Icon(Icons.today),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime.now();
                    _selectedDay = DateTime.now();
                  });
                },
                tooltip: 'Today',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: TableCalendar(
        firstDay: DateTime(2025, 10, 15),
        lastDay: DateTime(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDateSelected(selectedDay);
          }
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final tasks = _getTasksForDay(date);
            if (tasks.isEmpty) return null;

            // Check if there's a high priority task
            final hasHighPriority = tasks.any((task) => task.priority == 1);

            return Positioned(
              bottom: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show priority indicator if there's a high priority task
                  if (hasHighPriority)
                    Container(
                      margin: const EdgeInsets.only(right: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                    ),
                  // Show category dots
                  ...tasks.take(3).map((task) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(task.category),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
          weekendTextStyle: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF6B6B6B),
          ),
          outsideTextStyle: TextStyle(
            color: isDark ? Colors.white30 : const Color(0xFFBDBDBD),
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF6B6B6B),
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF6B6B6B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDateHeader() {
    final taskCount = _getTasksForDay(_selectedDay).length;
    final completedCount = _getTasksForDay(
      _selectedDay,
    ).where((t) => t.isCompleted).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(_selectedDay),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$completedCount of $taskCount tasks completed',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          if (taskCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Text(
                '$taskCount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _build24HourTimeline() {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        120,
      ), // Added bottom padding for navbar
      itemCount: 24,
      itemBuilder: (context, hour) {
        final timeString = '${hour.toString().padLeft(2, '0')}:00';
        final tasksAtHour = widget.tasks.where((task) {
          try {
            final taskHour = int.parse(task.time.split(':')[0]);
            final matchesDate = DateUtils.isSameDay(task.date, _selectedDay);
            return taskHour == hour && matchesDate;
          } catch (e) {
            return false;
          }
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Time marker
                  Row(
                    children: [
                      SizedBox(
                        width: 45,
                        child: Text(
                          timeString,
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey[500]
                                : const Color(0xFF9E9E9E),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 1,
                        color: isDark
                            ? Colors.grey[700]
                            : const Color(0xFFE0E0E0),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: isDark
                          ? Colors.grey[900]
                          : const Color(0xFFEEEEEE),
                    ),
                  ),
                ],
              ),
              if (tasksAtHour.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...tasksAtHour.map((task) => _buildTimelineTaskCard(task)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineTaskCard(Task task) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF6B6B6B);
    final categoryColor = _getCategoryColor(task.category);

    return GestureDetector(
      onTap: () => _showTaskOptions(task),
      onLongPress: () => _showTaskOptions(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 60),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (task.isCompleted)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                Text(
                  task.time,
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description,
                style: TextStyle(fontSize: 13, color: textSecondary),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: task.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.category,
                    style: TextStyle(fontSize: 12, color: task.color),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      task.priority,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getPriorityColor(
                        task.priority,
                      ).withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPriorityIcon(task.priority),
                        size: 12,
                        color: _getPriorityColor(task.priority),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getPriorityLabel(task.priority),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(task.priority),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return const Color(0xFF8A5DF4);
      case 'personal':
        return const Color(0xFFD62F6D);
      case 'projects':
        return const Color(0xFF4ECDC4);
      case 'study':
        return const Color(0xFFF4A261);
      case 'health':
        return const Color(0xFF06D6A0);
      default:
        return Colors.blue;
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return const Color(0xFFFF5252); // Red for high priority
      case 2:
        return const Color(0xFFFF9800); // Orange for medium priority
      case 3:
        return const Color(0xFF4CAF50); // Green for low priority
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icons.priority_high;
      case 2:
        return Icons.remove;
      case 3:
        return Icons.arrow_downward;
      default:
        return Icons.remove;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'None';
    }
  }
}
