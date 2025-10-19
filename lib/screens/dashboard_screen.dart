import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../widgets/animated_gradient_background.dart';
import 'profile_screen.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Task> _todayTasks = [
    Task(title: "Morning Standup", time: const TimeOfDay(hour: 9, minute: 30)),
    Task(
      title: "Code review for feature X",
      time: const TimeOfDay(hour: 11, minute: 0),
      isCompleted: true,
    ),
    Task(
      title: "Work on the new Profile UI",
      time: const TimeOfDay(hour: 14, minute: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FIX: The AnimatedGradientBackground is a widget that wraps the screen's content.
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, "Today's Schedule"),
                    const SizedBox(height: 16),
                    // FIX: TaskCard is a class and must be instantiated.
                    ..._todayTasks.map((task) => TaskCard(task: task)).toList(),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Recent Journal Entry'),
                    const SizedBox(height: 16),
                    _buildRecentJournalCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, ${widget.user.name.split(' ')[0]} 👋',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          GestureDetector(
            // FIX: ProfileScreen is a class and must be instantiated.
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(user: widget.user),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF8A5DF4),
              child: Text(
                widget.user.name.isNotEmpty ? widget.user.name[0] : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecentJournalCard(BuildContext context) {
    // FIX: Replaced GlassContainer with a manual, more flexible glassmorphism effect
    // that doesn't require fixed height and width.
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0x0DFFFFFF), // 0.05 opacity
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x33FFFFFF)), // 0.2 opacity
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: const Text(
              "A Productive Day",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8A5DF4),
              ),
            ),
            subtitle: const Text(
              "Managed to fix the YAML error and started designing...",
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
