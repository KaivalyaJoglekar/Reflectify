import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:reflectify/models/project_model.dart';
import 'package:reflectify/models/focus_session_model.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/providers/theme_provider.dart';
import 'package:reflectify/screens/enhanced_dashboard_screen.dart';
import 'package:reflectify/screens/task_management_screen.dart';
import 'package:reflectify/screens/enhanced_calendar_screen.dart';
import 'package:reflectify/screens/project_board_screen.dart';
import 'package:reflectify/screens/focus_mode_screen.dart';
import 'package:reflectify/screens/journal_timeline_screen.dart';
import 'package:reflectify/screens/daily_summary_screen.dart';
import 'package:reflectify/screens/full_profile_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/custom_toast.dart';
import 'package:reflectify/screens/add_journal_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MainNavigationScreen extends StatefulWidget {
  final User user;
  const MainNavigationScreen({super.key, required this.user});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Task> _tasks = [];
  final List<Project> _projects = [];
  final List<FocusSession> _focusSessions = [];
  final List<JournalEntry> _journalEntries = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFABPressed() {
    switch (_selectedIndex) {
      case 0: // Dashboard - Add Task
        _showAddTaskDialog();
        break;
      case 1: // Tasks - Add Task
        _showAddTaskDialog();
        break;
      case 2: // Calendar - Add Task/Event
        _showAddTaskDialog();
        break;
      case 3: // Projects - Add Project
        _showAddProjectDialog();
        break;
      case 4: // Focus - Start Session (handled in screen)
        break;
      case 5: // Journal - Add Entry
        _showAddJournalDialog();
        break;
      default:
        _showAddTaskDialog();
    }
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    DateTime selectedDate = DateTime(2025, 10, 15);
    TimeOfDay selectedTime = TimeOfDay.now();
    String selectedCategory = 'Personal';
    int selectedPriority = 2;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.6),
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
                            color: Colors.white.withOpacity(0.3),
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
                            color: Colors.white.withOpacity(0.3),
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
                              initialValue: selectedCategory,
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
                                    color: Colors.white.withOpacity(0.3),
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
                              initialValue: selectedPriority,
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
                                    color: Colors.white.withOpacity(0.3),
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
                                firstDate: DateTime(2025, 10, 15),
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
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
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
                                  selectedTime = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedTime.format(context),
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
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              final newTask = Task(
                                title: titleController.text,
                                time: selectedTime.format(context),
                                color: Theme.of(context).primaryColor,
                                projectName: 'General',
                                taskCount: 1,
                                date: taskDateTime,
                                description: descController.text,
                                category: selectedCategory,
                                priority: selectedPriority,
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

  void _showAddProjectDialog() {
    CustomToast.show(
      context,
      message: 'Project creation coming soon!',
      icon: Icons.folder,
      iconColor: const Color(0xFF4ECDC4),
    );
  }

  void _showAddJournalDialog() async {
    final newEntry = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddJournalScreen(selectedDate: DateTime(2025, 10, 15)),
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

  void _handleTaskDelete(Task task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
    CustomToast.show(
      context,
      message: 'Task deleted',
      icon: Icons.delete,
      iconColor: Colors.red,
    );
  }

  void _handleTaskReorder(Task task, Task targetTask) {
    setState(() {
      final taskIndex = _tasks.indexOf(task);
      final targetIndex = _tasks.indexOf(targetTask);
      _tasks.removeAt(taskIndex);
      _tasks.insert(targetIndex, task);
    });
  }

  void _handleSessionComplete(FocusSession session) {
    setState(() {
      _focusSessions.add(session);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      // 0: Enhanced Dashboard
      EnhancedDashboardScreen(
        user: widget.user,
        tasks: _tasks,
        projects: _projects,
        onTaskComplete: _handleTaskComplete,
        onAddTask: _showAddTaskDialog,
        onViewCalendar: () => setState(() => _selectedIndex = 2),
        onViewProjects: () => setState(() => _selectedIndex = 3),
      ),
      // 1: Task Management
      TaskManagementScreen(
        tasks: _tasks,
        onTaskComplete: _handleTaskComplete,
        onTaskDelete: _handleTaskDelete,
        onTaskReorder: _handleTaskReorder,
        onTaskEdit: (task) {
          CustomToast.show(
            context,
            message: 'Edit coming soon!',
            icon: Icons.edit,
          );
        },
      ),
      // 2: Calendar
      EnhancedCalendarScreen(
        tasks: _tasks,
        onDateSelected: (date) {},
        onTaskTap: (task) {
          CustomToast.show(context, message: task.title, icon: Icons.info);
        },
      ),
      // 3: Projects
      ProjectBoardScreen(
        projects: _projects,
        tasks: _tasks,
        onTaskStatusChange: (task, status) {},
        onProjectTap: (project) {},
        onAddProject: _showAddProjectDialog,
      ),
      // 4: Focus Mode
      FocusModeScreen(
        sessions: _focusSessions,
        onSessionComplete: _handleSessionComplete,
      ),
      // 5: Journal
      JournalTimelineScreen(entries: _journalEntries, onEntryTap: (entry) {}),
      // 6: Analytics
      DailySummaryScreen(tasks: _tasks, focusSessions: _focusSessions),
      // 7: Profile
      FullProfileScreen(user: widget.user),
    ];

    return AppBackground(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: IndexedStack(index: _selectedIndex, children: screens),
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
                  Theme.of(context).primaryColor.withOpacity(0.5),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61',
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
          _buildDrawerItem(Icons.timer, 'Focus Mode', 4),
          _buildDrawerItem(Icons.book, 'Journal', 5),
          _buildDrawerItem(Icons.analytics, 'Analytics', 6),
          _buildDrawerItem(Icons.person, 'Profile', 7),
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
    return SafeArea(
      child: Container(
        height: 60,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: BottomAppBar(
                padding: EdgeInsets.zero,
                height: 60,
                color: Colors.transparent,
                elevation: 0,
                notchMargin: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _buildNavItem(0, Icons.dashboard_rounded, 'Dashboard')),
                    Expanded(child: _buildNavItem(1, Icons.task_alt_rounded, 'Tasks')),
                    Expanded(child: _buildNavItem(2, Icons.calendar_today_rounded, 'Calendar')),
                    const SizedBox(width: 30), // Space for FAB
                    Expanded(child: _buildNavItem(5, Icons.book_rounded, 'Journal')),
                    Expanded(child: _buildNavItem(6, Icons.analytics_rounded, 'Analytics')),
                    Expanded(child: _buildNavItem(7, Icons.person_rounded, 'Profile')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final color = isSelected
        ? Theme.of(context).primaryColor
        : Colors.white.withOpacity(0.6);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildFAB() {
    if (_selectedIndex == 4) return null; // No FAB for Focus Mode

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        onPressed: _onFABPressed,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
