import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/widgets/project_card.dart';
import 'package:reflectify/utils/streak_calculator.dart';

class DashboardScreen extends StatelessWidget {
  final User user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
              const SizedBox(height: 32),
              _buildSearchBar(context),
              const SizedBox(height: 32),
              _buildSectionHeader('Project', () {}),
              const SizedBox(height: 16),
              _buildProjectList(),
              const SizedBox(height: 32),
              _buildSectionHeader('Progress', () {}),
              const SizedBox(height: 16),
              _buildDailyTaskCard(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    // Get current streak from shared calculator
    final int currentStreak = StreakCalculator.calculateCurrentStreak();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Day',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  user.name,
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
            // Streak Fire Icon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFFF6B35),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$currentStreak',
                    style: const TextStyle(
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
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

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search task...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: onSeeAll, child: const Text('See All')),
      ],
    );
  }

  Widget _buildProjectList() {
    return const Row(
      children: [
        Expanded(
          child: ProjectCard(
            title: 'Redesign main page',
            tasks: 7,
            date: '25.10.25 (11pm)',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ProjectCard(
            title: 'UI/UX Medical Dashboard',
            tasks: 10,
            date: '18.10.25 (10pm)',
          ),
        ),
      ],
    );
  }

  Widget _buildDailyTaskCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8A5DF4).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create and Check\nDaily Task',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can control the execution of a task by a\ncommand in the application',
            style: TextStyle(color: Colors.grey[400], height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateChip(context, 'MON', '15', isSelected: true),
              _buildDateChip(context, 'TUE', '16'),
              _buildDateChip(context, 'WED', '17'),
              _buildDateChip(context, 'THU', '18'),
              _buildDateChip(context, 'FRI', '19'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 36, // Fixed height to prevent overflow
            child: Stack(
              children: List.generate(
                7,
                (index) => Positioned(
                  left: index * 25.0, // Overlap avatars
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=${index + 10}',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(
    BuildContext context,
    String day,
    String date, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isSelected ? null : Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
