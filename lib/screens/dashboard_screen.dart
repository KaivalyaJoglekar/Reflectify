import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/widgets/project_card.dart';

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
            _buildDailyTaskCard(context),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  user.name,
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
        fillColor: const Color(0xFF1E1E1E),
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
      height: 150, // Give the horizontal list a fixed height
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          SizedBox(
            width: 200, // Give the cards a fixed width
            child: ProjectCard(
              color: Colors.pink,
              title: 'Redesign main page',
              tasks: 7,
              date: '25.10 (11pm)',
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 200, // Give the cards a fixed width
            child: ProjectCard(
              color: Colors.orange,
              title: 'UI/UX Medical Dashboard',
              tasks: 10,
              date: '18.09 (10pm)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTaskCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create and Check\nDaily Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'You can control the execution of a task by a command in the application',
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateChip(context, 'MON', '15', true),
              _buildDateChip(context, 'TUE', '16', false),
              _buildDateChip(context, 'WED', '17', false),
              _buildDateChip(context, 'THU', '18', false),
              _buildDateChip(context, 'FRI', '19', false),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=a${index}',
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDateChip(
      BuildContext context, String day, String date, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}