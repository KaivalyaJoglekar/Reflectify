import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/dashboard_screen.dart';
import 'package:reflectify/screens/schedule_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/screens/journal_list_screen.dart';
import 'package:reflectify/screens/add_journal_screen.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:reflectify/screens/full_profile_screen.dart';
import 'package:reflectify/widgets/custom_toast.dart';

class NavigationScreen extends StatefulWidget {
  final User user;
  const NavigationScreen({super.key, required this.user});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _tasks = [];
  DateTime _selectedTaskDate = DateTime(2025, 10, 15);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFABPressed() {
    if (_selectedIndex == 2) {
      // Journal tab - add journal entry
      _showAddJournalDialog();
    } else {
      // Other tabs - add task
      _showAddTaskDialog(context);
    }
  }

  void _showAddJournalDialog() async {
    final newEntry = await Navigator.of(context).push(
      MaterialPageRoute(
        // FIXED: Removed selectedDate parameter as AddJournalScreen no longer accepts it.
        builder: (context) => const AddJournalScreen(),
        fullscreenDialog: true,
      ),
    );

    if (newEntry != null && newEntry is JournalEntry) {
      CustomToast.show(
        context,
        message: 'Journal entry added!',
        icon: Icons.book,
        iconColor: const Color(0xFFD62F6D),
      );
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    DateTime selectedDate = _selectedTaskDate;
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Date and Time Pickers Row
                    Row(
                      children: [
                        // Date Picker
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2025, 10, 15),
                                lastDate: DateTime(2030, 12, 31),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Theme.of(context).primaryColor,
                                        onPrimary: Colors.white,
                                        surface: const Color(0xFF1C1C1E),
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
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Time Picker
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Theme.of(context).primaryColor,
                                        onPrimary: Colors.white,
                                        surface: const Color(0xFF1C1C1E),
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
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description (optional)',
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
                              setState(() {
                                _tasks.add({
                                  'title': titleController.text,
                                  'description': descController.text,
                                  'completed': false,
                                  'createdAt': taskDateTime,
                                });
                                _selectedTaskDate = selectedDate;
                              });
                              Navigator.pop(context);
                              CustomToast.show(
                                context,
                                message:
                                    'Task added for ${DateFormat('MMM d').format(selectedDate)} at ${selectedTime.format(context)}!',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add Task',
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

  @override
  Widget build(BuildContext context) {
    // Build widget options dynamically with current tasks
    final widgetOptions = <Widget>[
      DashboardScreen(user: widget.user),
      ScheduleScreen(tasks: _tasks),
      // FIXED: Removed tasks parameter as JournalListScreen no longer accepts it.
      const JournalListScreen(),
      FullProfileScreen(user: widget.user),
    ];

    return AppBackground(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: IndexedStack(index: _selectedIndex, children: widgetOptions),
        bottomNavigationBar: _buildTransparentBottomBar(),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _onFABPressed,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildTransparentBottomBar() {
    // UPDATED: Applied glassmorphism effect
    return Container(
      height: 75,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        // 1. Add the tint color
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          // 2. Add the blur
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomAppBar(
            // 3. Make the bar itself transparent
            color: Colors.transparent,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(0, Icons.home_rounded),
                _buildNavItem(1, Icons.calendar_today_rounded),
                const SizedBox(width: 48), // Space for FAB
                _buildNavItem(2, Icons.book_rounded),
                _buildNavItem(3, Icons.person_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.white54,
        size: 28,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}