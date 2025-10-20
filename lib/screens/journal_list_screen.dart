import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/widgets/journal_card.dart';
import 'package:reflectify/screens/add_journal_screen.dart'; // ADDED

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
      content:
          "Managed to fix a long-standing bug and started designing the new journaling stats screen. Feeling accomplished.",
      date: DateTime.now(),
    ),
    JournalEntry(
      title: "Thoughts on the Rain",
      content:
          "The sound of rain is incredibly calming. It's a perfect day to reflect on the past week and plan for the next.",
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    JournalEntry(
      title: "Planning the Weekend",
      content:
          "Setting my intentions for a restful and productive weekend. Need to finish the table calendar implementation.",
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // ADDED
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onNewEntry() async {
    // ADDED
    final newEntry = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddJournalScreen(selectedDate: _selectedDay ?? DateTime.now()),
        fullscreenDialog: true,
      ),
    );

    if (newEntry != null && newEntry is JournalEntry) {
      // Logic to save to database/provider and refresh list
      setState(() {
        _allEntries.add(newEntry);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline), // MODIFIED
            onPressed: _onNewEntry, // MODIFIED
            tooltip: 'Add Entry for Selected Day',
          ),
        ],
      ),
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
              // MODIFIED: Filter entries for the selected day
              children: _allEntries
                  .where((entry) => isSameDay(entry.date, _selectedDay))
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
      onDaySelected: _onDaySelected, // MODIFIED
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
