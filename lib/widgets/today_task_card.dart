// lib/widgets/today_task_card.dart
// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

class TodayTaskCard extends StatelessWidget {
  // Use properties directly instead of a complex model
  final String title;
  final String subtitle;
  final int progress;
  final Color color;
  final String dueDate;
  final int teamCount;

  const TodayTaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    required this.dueDate,
    required this.teamCount,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.white54),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const Spacer(),
              const Text(
                'Progress',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$progress%',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Mock Avatars Stack
                  Row(
                    children: List.generate(
                      3,
                      (index) => Align(
                        widthFactor: 0.6,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              Colors.primaries[index % Colors.primaries.length],
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
                  Text(
                    ' +$teamCount',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dueDate,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
