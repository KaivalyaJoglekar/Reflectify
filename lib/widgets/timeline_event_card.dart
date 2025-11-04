// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TimelineEventCard extends StatelessWidget {
  final String title;
  final String startTime;
  final String endTime;
  final String? description;
  final Color accentColor;
  final bool hasVideoCall;
  final List<String>? participantAvatars;
  final VoidCallback? onTap;

  const TimelineEventCard({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.description,
    required this.accentColor,
    this.hasVideoCall = false,
    this.participantAvatars,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: accentColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (hasVideoCall)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.videocam,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '$startTime - $endTime',
                      style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                    ),
                  ],
                ),
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  ),
                ],
                if (participantAvatars != null &&
                    participantAvatars!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (int i = 0; i < participantAvatars!.length; i++)
                        Align(
                          widthFactor: 0.7,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF1F1F1F),
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(participantAvatars![i]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
