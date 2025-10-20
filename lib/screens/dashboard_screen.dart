// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:reflectify/screens/profile_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/custom_search_bar.dart';
import 'package:reflectify/widgets/today_task_card.dart';
import 'package:reflectify/widgets/all_task_list_item.dart';
import '../models/user_model.dart';

// Reverted to StatelessWidget and removed all problematic list logic
class DashboardScreen extends StatelessWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  // Mock data declared as const Lists of Maps (the safest const type)
  final List<Map<String, dynamic>> _todayTasks = const [
    {
      'title': "App Design",
      'subtitle': "Task management mobile app",
      'progress': 52,
      'color': Color(0xFF5A8DFF),
      'dueDate': 'Mar 02',
      'teamCount': 5,
    },
    {
      'title': "Dashboard",
      'subtitle': "Revision home page",
      'progress': 75,
      'color': Color(0xFF8A5DF4),
      'dueDate': 'Mar 02',
      'teamCount': 5,
    },
  ];

  final List<Map<String, dynamic>> _allTasks = const [
    {
      'agency': "Design Agency",
      'title': "Create details landing page",
      'count': 20,
      'time': "4hour",
    },
    {
      'agency': "Design Agency",
      'title': "Create details landing page",
      'count': 20,
      'time': "4hour",
    },
    {
      'agency': "Web Development",
      'title': "Implement login flow",
      'count': 15,
      'time': "3hour",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(const [
                    // Removed const from delegate and added to its children
                    SizedBox.shrink(), // Placeholder for _buildAppBar
                    SizedBox(height: 24),
                    CustomSearchBar(),
                    SizedBox(height: 32),
                    SizedBox.shrink(), // Placeholder for _buildSectionHeader (Today Task)
                    SizedBox(height: 16),
                  ]),
                ),
              ),

              // Re-implementing the header and sections without const list literal errors
              SliverToBoxAdapter(child: _buildAppBar(context, user)),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomSearchBar(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildSectionHeader(
                    context,
                    'Today Task',
                    actionText: '+ Add',
                    onActionTap: () {},
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Horizontal list for Today Tasks
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _todayTasks.length,
                      itemBuilder: (context, index) {
                        final task = _todayTasks[index];
                        return TodayTaskCard(
                          title: task['title'],
                          subtitle: task['subtitle'],
                          progress: task['progress'],
                          color: task['color'],
                          dueDate: task['dueDate'],
                          teamCount: task['teamCount'],
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildSectionHeader(
                    context,
                    'All Task',
                    actionText: '+ New Task',
                    onActionTap: () {},
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // List for All Tasks
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final task = _allTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AllTaskListItem(
                      agency: task['agency'],
                      title: task['title'],
                      count: task['count'],
                      time: task['time'],
                    ),
                  );
                }, childCount: _allTasks.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods (Copied from previous step, ensuring const/static correctness) ---
  Widget _buildAppBar(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Profile Picture
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: user),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF5A8DFF),
                  child: Text('A', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Alina',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Be useful right now.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 24),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.grid_view_rounded, size: 24),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    String actionText = '',
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
