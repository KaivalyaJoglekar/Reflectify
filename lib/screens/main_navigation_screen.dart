import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:reflectify/models/project_model.dart';
import 'package:reflectify/models/focus_session_model.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/models/focus_history_model.dart';
import 'package:reflectify/providers/theme_provider.dart';
import 'package:reflectify/screens/enhanced_dashboard_screen.dart';
import 'package:reflectify/screens/enhanced_calendar_screen.dart';
import 'package:reflectify/screens/focus_mode_screen.dart';
import 'package:reflectify/screens/journal_timeline_screen.dart';
import 'package:reflectify/screens/full_profile_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/custom_toast.dart';
import 'package:reflectify/screens/add_journal_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';

class MainNavigationScreen extends StatefulWidget {
  final User user;
  const MainNavigationScreen({super.key, required this.user});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Task> _tasks = [];
  final List<Project> _projects = [];
  final List<FocusSession> _focusSessions = [];
  final List<JournalEntry> _journalEntries = [];
  final List<FocusHistory> _focusHistory = [];
  bool _expandCalendar = false; // NEW: Track if calendar should be expanded

  // Firebase
  late DatabaseReference _tasksRef;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _loadTasksFromFirebase();
  }

  void _initializeFirebase() {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
      _tasksRef = FirebaseDatabase.instance.ref('users/$_userId/tasks');
    }
  }

  Future<void> _loadTasksFromFirebase() async {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final snapshot = await _tasksRef.get();
      if (snapshot.exists) {
        final tasksData = snapshot.value as Map<dynamic, dynamic>;
        final loadedTasks = <Task>[];

        tasksData.forEach((key, value) {
          try {
            final task = Task.fromJson(value as Map<dynamic, dynamic>);
            loadedTasks.add(task);
          } catch (e) {
            debugPrint('Error loading task: $e');
          }
        });

        setState(() {
          _tasks.clear();
          _tasks.addAll(loadedTasks);
        });
      }
    } catch (e) {
      debugPrint('Error loading tasks from Firebase: $e');
    }
  }

  Future<void> _saveTaskToFirebase(Task task) async {
    try {
      await _tasksRef.child(task.id).set(task.toJson());
    } catch (e) {
      debugPrint('Error saving task to Firebase: $e');
      if (mounted) {
        CustomToast.show(
          context,
          message: 'Failed to save task',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }
    }
  }

  Future<void> _deleteTaskFromFirebase(String taskId) async {
    try {
      await _tasksRef.child(taskId).remove();
    } catch (e) {
      debugPrint('Error deleting task from Firebase: $e');
      if (mounted) {
        CustomToast.show(
          context,
          message: 'Failed to delete task',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }
    }
  }

  Future<void> _updateTaskInFirebase(Task task) async {
    try {
      await _tasksRef.child(task.id).update(task.toJson());
    } catch (e) {
      debugPrint('Error updating task in Firebase: $e');
      if (mounted) {
        CustomToast.show(
          context,
          message: 'Failed to update task',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _expandCalendar = false; // Reset when changing tabs
    });
  }

  void _navigateToCalendarExpanded() {
    setState(() {
      _selectedIndex = 1; // Navigate to Tasks/Calendar screen
      _expandCalendar = true; // Expand the calendar
    });
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullProfileScreen(
          user: widget.user,
          tasks: _tasks,
          focusSessions: _focusSessions,
          journalEntries: _journalEntries,
        ),
      ),
    );
  }

  void _onFABPressed() {
    switch (_selectedIndex) {
      case 0: // Dashboard - Add Task
        _showAddTaskDialog();
        break;
      case 1: // Tasks/Calendar - Add Task
        _showAddTaskDialog();
        break;
      case 2: // Focus Mode - Not used (has its own controls)
        break;
      case 3: // Journal - Add Entry
        _showAddJournalDialog();
        break;
      default:
        _showAddTaskDialog();
    }
  }

  void _onFocusSessionComplete(FocusHistory session) {
    setState(() {
      _focusHistory.add(session);
    });
    CustomToast.show(
      context,
      message: session.completed
          ? '🎉 Focus session completed!'
          : 'Focus session stopped',
      icon: session.completed ? Icons.check_circle : Icons.info,
      iconColor: session.completed ? Colors.green : Colors.orange,
    );
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    DateTime selectedDate = DateTime.now(); // Default to today
    TimeOfDay selectedStartTime = TimeOfDay.now();
    TimeOfDay selectedEndTime = TimeOfDay(
      hour: (TimeOfDay.now().hour + 1) % 24,
      minute: TimeOfDay.now().minute,
    ); // Default to 1 hour later
    String selectedCategory = 'Personal';
    int selectedPriority = 2;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Task',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<String>(
                              isDense: true,
                              isExpanded: true,
                              menuMaxHeight: 300,
                              initialValue:
                                  selectedCategory, // FIXED: Use value
                              dropdownColor: const Color(0xFF1C1C1E),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                labelText: 'Category',
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items:
                                  [
                                        'Personal',
                                        'Work',
                                        'Projects',
                                        'Study',
                                        'Health',
                                      ]
                                      .map(
                                        (cat) => DropdownMenuItem<String>(
                                          value: cat,
                                          child: Text(
                                            cat,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    selectedCategory = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<int>(
                              isDense: true,
                              isExpanded: true,
                              menuMaxHeight: 300,
                              initialValue:
                                  selectedPriority, // FIXED: Use value
                              dropdownColor: const Color(0xFF1C1C1E),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                labelText: 'Priority',
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    'High',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text(
                                    'Medium',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text(
                                    'Low',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    selectedPriority = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    DateFormat(
                                      'MMM d, yyyy',
                                    ).format(selectedDate),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Start Time and End Time Row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedStartTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  selectedStartTime = picked;
                                  // Auto-adjust end time if it's before start time
                                  final startMinutes =
                                      picked.hour * 60 + picked.minute;
                                  final endMinutes =
                                      selectedEndTime.hour * 60 +
                                      selectedEndTime.minute;
                                  if (endMinutes <= startMinutes) {
                                    selectedEndTime = TimeOfDay(
                                      hour: (picked.hour + 1) % 24,
                                      minute: picked.minute,
                                    );
                                  }
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Start',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedStartTime.format(context),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedEndTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                // Validate that end time is after start time
                                final startMinutes =
                                    selectedStartTime.hour * 60 +
                                    selectedStartTime.minute;
                                final endMinutes =
                                    picked.hour * 60 + picked.minute;

                                if (endMinutes > startMinutes) {
                                  setDialogState(() {
                                    selectedEndTime = picked;
                                  });
                                } else {
                                  // Show error message
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'End time must be after start time',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'End',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedEndTime.format(context),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty) {
                              final taskDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedStartTime.hour,
                                selectedStartTime.minute,
                              );

                              // Format time as "start - end" with explicit AM/PM
                              String formatTimeOfDay(TimeOfDay time) {
                                final hour = time.hourOfPeriod == 0
                                    ? 12
                                    : time.hourOfPeriod;
                                final minute = time.minute.toString().padLeft(
                                  2,
                                  '0',
                                );
                                final period = time.period == DayPeriod.am
                                    ? 'AM'
                                    : 'PM';
                                return '$hour:$minute $period';
                              }

                              final timeString =
                                  '${formatTimeOfDay(selectedStartTime)} - ${formatTimeOfDay(selectedEndTime)}';

                              // FIXED: Create a Task object that matches the model
                              final newTask = Task(
                                id: UniqueKey().toString(), // Add a unique ID
                                title: titleController.text,
                                time:
                                    timeString, // Format: "9:00 AM - 10:00 AM"
                                color: Theme.of(
                                  context,
                                ).primaryColor, // Add required color parameter
                                projectName:
                                    selectedCategory, // Add required projectName parameter
                                taskCount:
                                    1, // Add required taskCount parameter
                                date: taskDateTime,
                                description: descController.text,
                                deadline: taskDateTime, // Use the same for now
                                priority: selectedPriority,
                                category: selectedCategory,
                                isCompleted: false, // Default to false
                              );

                              setState(() {
                                _tasks.add(newTask);
                              });

                              Navigator.pop(context);
                              CustomToast.show(
                                context,
                                message: 'Task created successfully!',
                                icon: Icons.check_circle,
                                iconColor: const Color(0xFF8A5DF4),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Create',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    final TextEditingController titleController = TextEditingController(
      text: task.title,
    );
    final TextEditingController descController = TextEditingController(
      text: task.description,
    );
    DateTime selectedDate = task.date;

    // Parse the time string (format: "9:00 AM - 10:00 AM" or "09:00")
    TimeOfDay selectedStartTime = TimeOfDay.now();
    try {
      if (task.time.contains('-')) {
        // Format: "9:00 AM - 10:00 AM"
        final startTimeStr = task.time.split('-')[0].trim();
        final format24 = DateFormat.jm();
        final parsedTime = format24.parse(startTimeStr);
        selectedStartTime = TimeOfDay(
          hour: parsedTime.hour,
          minute: parsedTime.minute,
        );
      } else if (task.time.contains(':')) {
        // Format: "09:00" or "9:00"
        final timeParts = task.time.split(':');
        selectedStartTime = TimeOfDay(
          hour: int.parse(timeParts[0].trim()),
          minute: int.parse(timeParts[1].trim()),
        );
      }
    } catch (e) {
      // If parsing fails, use current time
      selectedStartTime = TimeOfDay.now();
    }

    String selectedCategory = task.category;
    int selectedPriority = task.priority;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Task',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            dropdownColor: const Color(0xFF1C1C1E),
                            decoration: InputDecoration(
                              labelText: 'Category',
                              labelStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items:
                                [
                                      'Personal',
                                      'Work',
                                      'Projects',
                                      'Study',
                                      'Health',
                                    ]
                                    .map(
                                      (cat) => DropdownMenuItem<String>(
                                        value: cat,
                                        child: Text(cat),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  selectedCategory = val;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: selectedPriority,
                            dropdownColor: const Color(0xFF1C1C1E),
                            decoration: InputDecoration(
                              labelText: 'Priority',
                              labelStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('High')),
                              DropdownMenuItem(value: 2, child: Text('Medium')),
                              DropdownMenuItem(value: 3, child: Text('Low')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  selectedPriority = val;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2025, 10, 15),
                          lastDate: DateTime(2030, 12, 31),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM dd, yyyy').format(selectedDate),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedStartTime,
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  selectedStartTime = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start Time',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedStartTime.format(context),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty) {
                              final updatedTask = task.copyWith(
                                title: titleController.text,
                                description: descController.text,
                                category: selectedCategory,
                                priority: selectedPriority,
                                date: selectedDate,
                                time: selectedStartTime.format(context),
                                color: _getCategoryColor(selectedCategory),
                              );

                              setState(() {
                                final index = _tasks.indexWhere(
                                  (t) => t.id == task.id,
                                );
                                if (index != -1) {
                                  _tasks[index] = updatedTask;
                                }
                              });

                              Navigator.pop(context);
                              CustomToast.show(
                                context,
                                message: 'Task updated!',
                                icon: Icons.check_circle,
                                iconColor: const Color(0xFF8A5DF4),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  void _navigateToFocusMode() {
    setState(() {
      _selectedIndex = 2; // Navigate to Focus Mode tab
    });
  }

  void _showAddJournalDialog() async {
    final newEntry = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            const AddJournalScreen(), // FIXED: Removed selectedDate
        fullscreenDialog: true,
      ),
    );

    if (newEntry != null && newEntry is JournalEntry) {
      setState(() {
        _journalEntries.add(newEntry);
      });
      if (mounted) {
        CustomToast.show(
          context,
          message: 'Journal entry added!',
          icon: Icons.book,
          iconColor: const Color(0xFFD62F6D),
        );
      }
    }
  }

  void _handleTaskComplete(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      }
    });
  }

  void _handleTaskToggleComplete(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        final wasCompleted = task.isCompleted;
        _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
        CustomToast.show(
          context,
          message: wasCompleted
              ? 'Task marked as incomplete'
              : 'Task completed!',
          icon: wasCompleted
              ? Icons.radio_button_unchecked
              : Icons.check_circle,
          iconColor: wasCompleted ? Colors.grey : Colors.green,
        );
      }
    });
  }

  void _handleTaskDelete(Task task) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        title: const Text(
          'Delete Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _tasks.removeWhere((t) => t.id == task.id);
              });
              CustomToast.show(
                context,
                message: 'Task deleted',
                icon: Icons.delete,
                iconColor: Colors.red,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleTaskEdit(Task task) {
    _showEditTaskDialog(task);
  }

  @override
  Widget build(BuildContext context) {
    // Screen list with 4 tabs: Dashboard, Tasks, Focus, Journal (Profile removed from navbar)
    final screens = <Widget>[
      // 0: Enhanced Dashboard
      RepaintBoundary(
        child: EnhancedDashboardScreen(
          key: ValueKey(
            _tasks.length + _tasks.where((t) => t.isCompleted).length,
          ),
          user: widget.user,
          tasks: _tasks,
          projects: _projects,
          onTaskComplete: _handleTaskComplete,
          onAddTask: _showAddTaskDialog,
          onViewCalendar: _navigateToCalendarExpanded,
          onFocusMode: _navigateToFocusMode,
          onProfileTap: _navigateToProfile,
          onAddJournal: _showAddJournalDialog,
        ),
      ),
      // 1: Tasks (Calendar with Timeline)
      RepaintBoundary(
        child: EnhancedCalendarScreen(
          key: ValueKey(
            _tasks.length +
                _tasks.where((t) => t.isCompleted).length +
                (_expandCalendar ? 1 : 0),
          ),
          tasks: _tasks,
          onDateSelected: (date) {},
          onTaskTap: (task) {},
          onTaskEdit: _handleTaskEdit,
          onTaskDelete: _handleTaskDelete,
          onTaskToggleComplete: _handleTaskToggleComplete,
          expandCalendar: _expandCalendar, // Pass the expand flag
        ),
      ),
      // 2: Focus Mode
      RepaintBoundary(
        child: FocusModeScreen(
          onSessionComplete: _onFocusSessionComplete,
          history: _focusHistory,
        ),
      ),
      // 3: Journal
      RepaintBoundary(
        child: JournalTimelineScreen(
          entries: _journalEntries,
          onEntryTap: (entry) {},
        ),
      ),
    ];

    // ... rest of your build method ...
    return AppBackground(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false, // Don't apply SafeArea to bottom to handle it manually
          child: IndexedStack(index: _selectedIndex, children: screens),
        ),
        drawer: _buildDrawer(),
        bottomNavigationBar: _buildBottomBar(),
        floatingActionButton: _buildFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.5),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    widget.user.name.isNotEmpty
                        ? widget.user.name[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(Icons.task_alt, 'Tasks', 1),
          _buildDrawerItem(Icons.calendar_month, 'Calendar', 2),
          _buildDrawerItem(Icons.folder, 'Projects', 3),
          // _buildDrawerItem(Icons.timer, 'Focus Mode', 4), // FIXED: Removed
          _buildDrawerItem(Icons.book, 'Journal', 4), // FIXED: Index 5 -> 4
          _buildDrawerItem(
            Icons.analytics,
            'Analytics',
            5,
          ), // FIXED: Index 6 -> 5
          _buildDrawerItem(Icons.person, 'Profile', 6), // FIXED: Index 7 -> 6
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white70),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              CustomToast.show(
                context,
                message: 'Settings coming soon!',
                icon: Icons.settings,
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeModeProvider);
              return ListTile(
                leading: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white70,
                ),
                title: Text(
                  themeMode == ThemeMode.dark ? 'Light Theme' : 'Dark Theme',
                ),
                onTap: () {
                  // Toggle theme by updating the state directly
                  ref
                      .read(themeModeProvider.notifier)
                      .state = themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 72,
      margin: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.of(context).padding.bottom +
            8, // Add bottom padding for nav buttons
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.grid_view_rounded, 'Dashboard'),
                  _buildNavItem(1, Icons.check_circle_outline_rounded, 'Tasks'),
                  const SizedBox(width: 56), // Space for FAB
                  _buildNavItem(2, Icons.timer_outlined, 'Focus'),
                  _buildNavItem(3, Icons.menu_book_rounded, 'Journal'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isSelected ? 1.0 : 0.9,
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withValues(alpha: 0.5),
                  letterSpacing: -0.1,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildFAB() {
    // Hide the FAB on Focus Mode (index 2) and any other screens where it's not needed
    if (_selectedIndex == 2) {
      return null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onFABPressed,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.3),
          child: const Center(
            child: Icon(Icons.add_rounded, size: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
