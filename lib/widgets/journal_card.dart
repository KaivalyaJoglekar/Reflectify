import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/dashboard_screen.dart'; // To access the JournalEntry model

class JournalCard extends StatelessWidget {
  final JournalEntry entry;

  const JournalCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF8A5DF4).withOpacity(0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            // Format the date nicely (e.g., "Fri, Oct 17" or "Yesterday")
            _formatEntryDate(entry.date),
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const Divider(height: 24, color: Colors.white12),
          Text(
            entry.content,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  // Helper function to format dates in a user-friendly way
  String _formatEntryDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMd().format(date); // "Oct 18, 2025"
    }
  }
}
