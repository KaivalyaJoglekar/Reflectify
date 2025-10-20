import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Color color;
  final String title;
  final int tasks;
  final String date;

  const ProjectCard({
    super.key,
    required this.color,
    required this.title,
    required this.tasks,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.task_alt, size: 16, color: Colors.white70),
              const SizedBox(width: 4),
              Text('$tasks Task', style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
              const SizedBox(width: 4),
              Text(date, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}