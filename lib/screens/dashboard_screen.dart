import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:reflectify/models/user_model.dart';

class DashboardScreen extends StatelessWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildAppBar(context),
            const SizedBox(height: 24),
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildSectionHeader('Project', () {}),
            const SizedBox(height: 16),
            _buildProjectList(),
            const SizedBox(height: 24),
            _buildSectionHeader('Progress', () {}),
            const SizedBox(height: 16),
            _buildDailyTaskCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              // Replace with your image asset
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?u=a042581f4e29026704d',
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Day',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                ),
                Text(
                  user.name.split(' ').first, // Show first name
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings, size: 28),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search task...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: onSeeAll, child: const Text('See All')),
      ],
    );
  }

  Widget _buildProjectList() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          ProjectCard(
            color: Colors.pink,
            title: 'Redesign main page',
            tasks: 7,
            date: '25.10 (11pm)',
          ),
          SizedBox(width: 16),
          ProjectCard(
            color: Colors.orange,
            title: 'UI/UX Medical Dashboard',
            tasks: 10,
            date: '18.09 (10pm)',
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTaskCard() {
    // This is a simplified version of the card
    return GlassContainer(
      height: 180,
      width: double.infinity,
      borderRadius: BorderRadius.circular(24),
      color: Colors.white.withOpacity(0.05),
      borderColor: Colors.white.withOpacity(0.2),
      blur: 15,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create and Check\nDaily Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'You can control the execution of a task',
            style: TextStyle(color: Colors.grey[400]),
          ),
          const Spacer(),
          // Placeholder for dates and avatars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // This can be built from a list of dates
              Row(
                children: const [
                  Text('MON 15'),
                  SizedBox(width: 8),
                  Text('TUE 16'),
                ],
              ),
              // Placeholder for stacked avatars
              const Text('Avatars'),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom widget for the project cards
class ProjectCard extends StatelessWidget {
  final Color color;
  final String title;
  final int tasks;
  final String date;

  const ProjectCard({
    Key? key,
    required this.color,
    required this.title,
    required this.tasks,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 150,
      width: 180,
      borderRadius: BorderRadius.circular(24),
      color: color.withOpacity(0.1),
      borderColor: color.withOpacity(0.5),
      blur: 15,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text('$tasks Task', style: TextStyle(color: Colors.grey[300])),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(color: Colors.grey[300])),
        ],
      ),
    );
  }
}
