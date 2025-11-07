import 'package:flutter/material.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalTimelineScreen extends StatefulWidget {
  final List<JournalEntry> entries;
  final Function(JournalEntry) onEntryTap;
  final Function(JournalEntry)? onEntryEdit;
  final Function(String)? onEntryDelete;
  final Function(JournalEntry)? onEntryUpdate;

  const JournalTimelineScreen({
    super.key,
    required this.entries,
    required this.onEntryTap,
    this.onEntryEdit,
    this.onEntryDelete,
    this.onEntryUpdate,
  });

  @override
  State<JournalTimelineScreen> createState() => _JournalTimelineScreenState();
}

class _JournalTimelineScreenState extends State<JournalTimelineScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Favorites', 'Recent'];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _showCalendar = true;

  List<JournalEntry> get _filteredEntries {
    var entries = List<JournalEntry>.from(widget.entries);

    switch (_selectedFilter) {
      case 'Favorites':
        entries = entries.where((e) => e.isFavorite).toList();
        entries.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Recent':
        entries.sort((a, b) => b.date.compareTo(a.date));
        entries = entries.take(20).toList();
        break;
      default:
        entries.sort((a, b) => b.date.compareTo(a.date));
    }

    return entries;
  }

  // Check if a date has journal entries
  bool _hasEntryOnDate(DateTime date) {
    return widget.entries.any(
      (entry) =>
          entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day,
    );
  }

  // Get entries for a specific date
  List<JournalEntry> _getEntriesForDate(DateTime date) {
    return widget.entries
        .where(
          (entry) =>
              entry.date.year == date.year &&
              entry.date.month == date.month &&
              entry.date.day == date.day,
        )
        .toList();
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

    // Only show day entries when calendar filter is active AND a non-today date is selected
    final showDayView =
        _showCalendar && !isSameDay(_selectedDay, DateTime.now());
    final List<JournalEntry> selectedDayEntries = showDayView
        ? _getEntriesForDate(_selectedDay)
        : [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            if (_showCalendar) _buildCalendar(),
            if (_showCalendar) const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 16),
            Expanded(
              child: showDayView && selectedDayEntries.isNotEmpty
                  ? _buildDayEntries(selectedDayEntries)
                  : _filteredEntries.isEmpty
                  ? _buildEmptyState()
                  : _buildTimeline(groupedEntries),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TableCalendar(
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime.now(), // Don't allow future dates
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        onDaySelected: (selectedDay, focusedDay) {
          // Don't allow selecting future dates
          if (selectedDay.isAfter(DateTime.now())) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot create entries for future dates'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          // Don't allow navigating to future months
          final now = DateTime.now();
          if (focusedDay.year > now.year ||
              (focusedDay.year == now.year && focusedDay.month > now.month)) {
            return;
          }
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            // Show yellow dot for dates with entries
            if (_hasEntryOnDate(date)) {
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            return null;
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white70),
          outsideTextStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          disabledTextStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          weekendStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget _buildDayEntries(List<JournalEntry> entries) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom + 120,
      ),
      itemCount: entries.length + 1, // +1 for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedDay = DateTime.now();
                        _focusedDay = DateTime.now();
                      });
                    },
                    icon: const Icon(Icons.today, size: 16),
                    label: const Text('Today'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        }
        return _buildTimelineEntry(entries[index - 1]);
      },
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
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BebasNeue',
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your personal growth tracker',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _showCalendar
                      ? Icons.calendar_view_month
                      : Icons.calendar_today,
                ),
                onPressed: () {
                  setState(() {
                    _showCalendar = !_showCalendar;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(),
              ),
            ],
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
                // Reset to today when changing filters
                _selectedDay = DateTime.now();
                _focusedDay = DateTime.now();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withValues(alpha: 0.3),
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
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom +
            120, // Dynamic padding for navbar + nav buttons
      ),
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
        color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
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
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
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
    final dayOfWeek = DateFormat('EEEE').format(entry.date);
    final date = DateFormat('MMMM d, yyyy').format(entry.date);

    return GestureDetector(
      onTap: () => _showEntryOptions(entry),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 50),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    moodColor.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: moodColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day and Date Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayOfWeek,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: moodColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: moodColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: moodColor.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(moodIcon, color: moodColor, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  entry.mood.capitalize(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: moodColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                entry.isFavorite = !entry.isFavorite;
                              });
                              // Update in Firebase
                              if (widget.onEntryUpdate != null) {
                                widget.onEntryUpdate!(entry);
                              }
                            },
                            child: Icon(
                              entry.isFavorite ? Icons.star : Icons.star_border,
                              color: entry.isFavorite
                                  ? Colors.amber
                                  : Colors.white.withValues(alpha: 0.5),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  if (entry.title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  // Content
                  Text(
                    entry.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Tags
                  if (entry.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: entry.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Mood Icon Circle (overlapping on left)
            Positioned(
              left: 0,
              top: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: moodColor.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: moodColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: moodColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(moodIcon, color: moodColor, size: 24),
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
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No journal entries yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start writing to track your journey',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.3),
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
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
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

  void _showEntryOptions(JournalEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.blue),
              title: const Text('View Entry'),
              onTap: () {
                Navigator.pop(context);
                widget.onEntryTap(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Edit Entry'),
              onTap: () {
                Navigator.pop(context);
                _editEntry(entry);
              },
            ),
            ListTile(
              leading: Icon(
                entry.isFavorite ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              title: Text(
                entry.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              ),
              onTap: () {
                setState(() {
                  entry.isFavorite = !entry.isFavorite;
                });
                // Update in Firebase
                if (widget.onEntryUpdate != null) {
                  widget.onEntryUpdate!(entry);
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Entry'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editEntry(JournalEntry entry) {
    Navigator.pushNamed(
      context,
      '/add_journal',
      arguments: entry, // Pass the entry to edit
    ).then((value) {
      if (value == true) {
        setState(() {
          // Refresh the list
        });
      }
    });
  }

  void _confirmDelete(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text('Delete Entry'),
        content: const Text(
          'Are you sure you want to delete this journal entry?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.entries.remove(entry);
              });
              // Delete from Firebase
              if (widget.onEntryDelete != null) {
                widget.onEntryDelete!(entry.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Entry deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
