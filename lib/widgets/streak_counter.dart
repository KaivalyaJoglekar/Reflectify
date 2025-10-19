import 'package:flutter/material.dart';

class StreakCounter extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final double? maxValue;
  final Color color;

  const StreakCounter({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(width: 4),
            if (unit != null)
              Text(unit!, style: Theme.of(context).textTheme.bodyMedium),
            if (maxValue != null)
              Text(
                '/ ${maxValue!.toInt()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (maxValue != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (double.tryParse(value) ?? 0.0) / maxValue!,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
      ],
    );
  }
}
