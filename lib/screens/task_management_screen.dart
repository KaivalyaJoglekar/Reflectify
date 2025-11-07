import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskManagementScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskComplete;
  final Function(Task) onTaskDelete;
  final Function(Task, Task) onTaskReorder;
  final Function(Task) onTaskEdit;

  const TaskManagementScreen({
    super.key,
    required this.tasks,
    required this.onTaskComplete,
    required this.onTaskDelete,
    required this.onTaskReorder,
    required this.onTaskEdit,
  });

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  DateTime _selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Task> get _tasksForSelectedDate {
    return widget.tasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList()..sort((a, b) {
      final timeA = _parseTime(a.time);
      final timeB = _parseTime(b.time);
      return timeA.compareTo(timeB);
    });
  }

  DateTime _parseTime(String time) {
    try {
      // Handle both "h:mm AM/PM" and "h:mm AM/PM - h:mm AM/PM" formats
      final parts = time.split(' - ')[0].trim();

      // Clean up the time string and extract components
      // Handle formats like "10:48 PM", "10:48PM", "10:48 pm"
      final cleanTime = parts.replaceAll(RegExp(r'\s+'), ' ').trim();

      // Try to extract AM/PM from the string
      String period = '';
      String timeWithoutPeriod = cleanTime;

      if (cleanTime.toUpperCase().contains('AM')) {
        period = 'AM';
        timeWithoutPeriod = cleanTime
            .replaceAll(RegExp(r'[aA][mM]'), '')
            .trim();
      } else if (cleanTime.toUpperCase().contains('PM')) {
        period = 'PM';
        timeWithoutPeriod = cleanTime
            .replaceAll(RegExp(r'[pP][mM]'), '')
            .trim();
      }

      // Now split the time part
      final timeParts = timeWithoutPeriod.split(':');
      if (timeParts.length < 2) {
        return DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          0,
          0,
        );
      }

      int hour = int.parse(timeParts[0].trim());
      // Extract only digits from minute part (in case there's still some text)
      final minuteStr = timeParts[1].replaceAll(RegExp(r'[^0-9]'), '');
      final minute = int.parse(minuteStr.isEmpty ? '0' : minuteStr);

      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        hour,
        minute,
      );
    } catch (e) {
      // Silently handle time parsing errors
      return DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        0,
        0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildWeekCalendar(),
            const SizedBox(height: 4),
            _buildCurrentTimeIndicator(),
            const SizedBox(height: 20),
            Expanded(child: _buildTaskTimeline()),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 48), // Spacer for visual balance
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            DateFormat('EEEE, d\'th\' MMMM yyyy').format(_selectedDate),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = startOfWeek.add(Duration(days: index));
              final isSelected =
                  date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;
              final isToday =
                  date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isToday && !isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.5)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTimeIndicator() {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  DateFormat('HH:mm').format(now),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTimeline() {
    final tasksForDay = _tasksForSelectedDate;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 24 * 80.0, // 24 hours * 80px per hour
          child: Stack(
            children: [
              // Timeline hours background
              Column(
                children: List.generate(24, (index) {
                  return _buildTimelineHour(index);
                }),
              ),
              // Tasks overlay
              if (tasksForDay.isNotEmpty)
                ...tasksForDay.map((task) => _buildTaskCard(task))
              else
                Positioned(
                  top: 200,
                  left: 60,
                  right: 0,
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
                        'No tasks for this day',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineHour(int hour) {
    final hourLabel = hour == 0
        ? '12 am'
        : hour < 12
        ? '$hour am'
        : hour == 12
        ? '12 pm'
        : '${hour - 12} pm';

    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hour label
          SizedBox(
            width: 60,
            child: Text(
              hourLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          // Horizontal line
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final colorScheme = _getPriorityColor(task.priority);
    final taskStartTime = _parseTime(task.time);
    final topPosition = _calculateTopPosition(taskStartTime);

    return Positioned(
      top: topPosition,
      left: 60,
      right: 0,
      child: Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => widget.onTaskEdit(task),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(16),
            ),
            SlidableAction(
              onPressed: (context) => widget.onTaskDelete(task),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, right: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colored vertical bar
              Container(
                width: 4,
                height: _calculateTaskHeight(task),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme, colorScheme.withOpacity(0.6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Task card
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTaskComplete(task),
                  child: Container(
                    height: _calculateTaskHeight(task),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? Colors.white.withOpacity(0.05)
                          : colorScheme.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: task.isCompleted
                            ? Colors.white.withOpacity(0.2)
                            : colorScheme.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: task.isCompleted
                                      ? Colors.white38
                                      : Colors.white,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Completion checkbox
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: task.isCompleted
                                    ? colorScheme
                                    : Colors.transparent,
                                border: Border.all(
                                  color: task.isCompleted
                                      ? colorScheme
                                      : Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: task.isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: task.isCompleted
                                ? Colors.white24
                                : Colors.white60,
                          ),
                        ),
                        if (task.description.isNotEmpty &&
                            _calculateTaskHeight(task) > 80) ...[
                          const SizedBox(height: 6),
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: task.isCompleted
                                  ? Colors.white24
                                  : Colors.white.withOpacity(0.5),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
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

  double _calculateTopPosition(DateTime time) {
    // Each hour takes 80px, calculate position from midnight
    final hoursSinceMidnight = time.hour + (time.minute / 60.0);
    return hoursSinceMidnight * 80;
  }

  double _calculateTaskHeight(Task task) {
    // Calculate height based on task duration (1 hour = 80px)
    try {
      final parts = task.time.split(' - ');
      if (parts.length == 2) {
        final start = _parseTime(parts[0].trim());
        final end = _parseTime(parts[1].trim());
        final duration = end.difference(start).inMinutes;
        if (duration > 0) {
          return (duration / 60 * 80).clamp(
            60.0,
            240.0,
          ); // Min 60, max 240 (3 hours)
        }
      }
    } catch (e) {
      // Silently handle task height calculation errors
    }
    return 80.0; // Default height (1 hour)
  }

  Color _getPriorityColor(int priority) {
    // Use existing priority colors from the app
    switch (priority) {
      case 1:
        return Colors.red; // High priority - Red
      case 2:
        return Colors.orange; // Medium priority - Orange
      case 3:
        return Colors.blue; // Low priority - Blue
      default:
        return Colors.grey; // Default - Grey
    }
  }

  Widget _buildAddButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, size: 28, color: Colors.white),
        onPressed: () {
          // Show add task dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add task functionality coming soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
