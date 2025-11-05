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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
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
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                task.isCompleted
                    ? Icons.radio_button_unchecked
                    : Icons.check_circle,
                color: Colors.green,
              ),
              title: Text(
                task.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
              ),
              onTap: () {
                Navigator.pop(context);
                if (widget.onTaskToggleComplete != null) {
                  widget.onTaskToggleComplete!(task);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Task'),
              onTap: () {
                Navigator.pop(context);
                if (widget.onTaskEdit != null) {
                  widget.onTaskEdit!(task);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Task'),
              onTap: () {
                Navigator.pop(context);
                if (widget.onTaskDelete != null) {
                  widget.onTaskDelete!(task);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
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
          color: Theme.of(context).primaryColor.withOpacity(0.5),
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

            return Positioned(
              bottom: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: tasks.take(3).map((task) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(task.category),
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
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
            color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                  color: Colors.white.withOpacity(0.6),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          border: Border.all(color: categoryColor.withOpacity(0.5), width: 1.5),
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
                    color: task.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.category,
                    style: TextStyle(fontSize: 12, color: task.color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> tasks) {
    // Group tasks by category
    final tasksByCategory = <String, List<Task>>{};
    for (var task in tasks) {
      if (!tasksByCategory.containsKey(task.category)) {
        tasksByCategory[task.category] = [];
      }
      tasksByCategory[task.category]!.add(task);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tasksByCategory.length,
      itemBuilder: (context, index) {
        final category = tasksByCategory.keys.elementAt(index);
        final categoryTasks = tasksByCategory[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${categoryTasks.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCategoryColor(category),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...categoryTasks.map((task) => _buildTaskCard(task)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final categoryColor = _getCategoryColor(task.category);
    final priorityColor = _getPriorityColor(task.priority);

    return GestureDetector(
      onTap: () => _showTaskOptions(task),
      onLongPress: () => _showTaskOptions(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: categoryColor.withOpacity(0.6), width: 2.0),
        ),
        child: Row(
          children: [
            Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : categoryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
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
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      if (task.deadline != null) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getPriorityLabel(task.priority),
                            style: TextStyle(
                              fontSize: 10,
                              color: priorityColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks for this date',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add a task',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
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
        return 'MED';
      case 3:
        return 'LOW';
      default:
        return '';
    }
  }
}
