import 'package:flutter/material.dart';

class TimelineEventCard extends StatelessWidget {
  final String time;
  final String eventTitle;
  final String eventTime;
  final Color color;
  final bool isFloating;

  const TimelineEventCard({
    super.key,
    required this.time,
    required this.eventTitle,
    required this.eventTime,
    required this.color,
    this.isFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Text(time, style: TextStyle(color: Colors.grey[400])),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(width: 4, color: color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                eventTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.more_horiz,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            eventTime,
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                          ),
                          if (isFloating) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Banking app structure and implement',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(
                                    4,
                                    (index) => Align(
                                      widthFactor: 0.7,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundImage: NetworkImage(
                                          'https://i.pravatar.cc/150?img=${index + 20}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
