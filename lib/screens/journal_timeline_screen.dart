import 'package:flutter/material.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:intl/intl.dart';

class JournalTimelineScreen extends StatefulWidget {
  final List<JournalEntry> entries;
  final Function(JournalEntry) onEntryTap;

  const JournalTimelineScreen({
    super.key,
    required this.entries,
    required this.onEntryTap,
  });

  @override
  State<JournalTimelineScreen> createState() => _JournalTimelineScreenState();
}

class _JournalTimelineScreenState extends State<JournalTimelineScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Milestones', 'Recent', 'Favorites'];

  List<JournalEntry> get _filteredEntries {
    var entries = List<JournalEntry>.from(widget.entries);

    switch (_selectedFilter) {
      case 'Milestones':
        entries = entries.where((e) => e.isMilestone).toList();
        break;
      case 'Recent':
        entries.sort((a, b) => b.date.compareTo(a.date));
        entries = entries.take(20).toList();
        break;
      case 'Favorites':
        // Could add a favorites feature
        break;
      default:
        entries.sort((a, b) => b.date.compareTo(a.date));
    }

    return entries;
  }

  Map<String, List<JournalEntry>> _groupEntriesByMonth() {
    final grouped = <String, List<JournalEntry>>{};
    for (var entry in _filteredEntries) {
      final monthKey = DateFormat('MMMM yyyy').format(entry.date);
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(entry);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedEntries = _groupEntriesByMonth();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 16),
            Expanded(
              child: widget.entries.isEmpty
                  ? _buildEmptyState()
                  : _buildTimeline(groupedEntries),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journal Timeline',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Your personal growth tracker',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.3),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline(Map<String, List<JournalEntry>> groupedEntries) {
    final months = groupedEntries.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];
        final entries = groupedEntries[month]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthHeader(month, entries.length),
            const SizedBox(height: 12),
            ...entries.map((entry) => _buildTimelineEntry(entry)),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildMonthHeader(String month, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            month,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(JournalEntry entry) {
    final moodIcon = _getMoodIcon(entry.mood);
    final moodColor = _getMoodColor(entry.mood);

    return GestureDetector(
      onTap: () => widget.onEntryTap(entry),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: entry.isMilestone
                        ? Colors.amber.withOpacity(0.3)
                        : moodColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: entry.isMilestone ? Colors.amber : moodColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    entry.isMilestone ? Icons.star : moodIcon,
                    color: entry.isMilestone ? Colors.amber : moodColor,
                    size: 20,
                  ),
                ),
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: moodColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            entry.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (entry.isMilestone)
                          const Icon(Icons.flag, color: Colors.amber, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(entry.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (entry.tags.isNotEmpty) ...[
                          Icon(
                            Icons.label,
                            size: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entry.tags.take(2).join(', '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No journal entries yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start writing to track your journey',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'excited':
        return Icons.celebration;
      case 'calm':
        return Icons.self_improvement;
      case 'anxious':
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return const Color(0xFF06D6A0);
      case 'sad':
        return const Color(0xFF6C8EBF);
      case 'excited':
        return const Color(0xFFF4A261);
      case 'calm':
        return const Color(0xFF8A5DF4);
      case 'anxious':
        return const Color(0xFFD62F6D);
      default:
        return Colors.grey;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          'Search Entries',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search by title or content...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
          ),
          onChanged: (value) {
            // Implement search functionality
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
