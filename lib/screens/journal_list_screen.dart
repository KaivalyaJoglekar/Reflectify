import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/widgets/journal_card.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Sample data for demonstration
  final List<JournalEntry> _allEntries = [
    JournalEntry(
      title: "A Productive Day",
      content: "...",
      date: DateTime.now(),
    ),
    JournalEntry(
      title: "Thoughts on the Rain",
      content: "...",
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    JournalEntry(
      title: "Planning the Weekend",
      content: "...",
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Entries')),
      body: Column(
        children: [
          _buildCalendar(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: _allEntries
                  .map((entry) => JournalCard(entry: entry))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final theme = Theme.of(context);
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: theme.textTheme.titleMedium!,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
