// lib/widgets/all_task_list_item.dart
import 'package:flutter/material.dart';

class AllTaskListItem extends StatelessWidget {
  // Use properties directly instead of a complex model
  final String agency;
  final String title;
  final int count;
  final String time;

  const AllTaskListItem({
    super.key,
    required this.agency,
    required this.title,
    required this.count,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                agency,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const Icon(Icons.more_vert, color: Colors.white54, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.copy, color: Colors.white54, size: 16),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.alarm, color: Colors.white54, size: 16),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const Spacer(),
              // Mock Avatars
              Row(
                children: List.generate(
                  3,
                  (index) => Align(
                    widthFactor: 0.6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey[400],
                      child: Text(
                        'A${index + 1}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
