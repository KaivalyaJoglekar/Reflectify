// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final int tasks;
  final String date;

  const ProjectCard({
    super.key,
    required this.title,
    required this.tasks,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    // Random colored borders for visual appeal
    final colors = [
      Theme.of(context).primaryColor,
      const Color(0xFF8A5DF4),
      const Color(0xFFD62F6D),
      const Color(0xFF06B6D4),
    ];
    final borderColor = colors[title.hashCode % colors.length];

    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 28, // Fixed height for avatar row
            child: Stack(
              children: List.generate(
                3,
                (index) => Positioned(
                  left: index * 20.0, // Overlap avatars
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=${index + 20}',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.watch_later_outlined,
                    size: 16,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.task_alt_outlined,
                    size: 16,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$tasks Task',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
