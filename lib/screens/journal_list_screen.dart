import 'package:flutter/material.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/widgets/journal_card.dart';
import 'package:reflectify/screens/add_journal_screen.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  DateTime _focusedDay = DateTime(2025, 10, 15);
  DateTime? _selectedDay;

  final List<JournalEntry> _allEntries = [
    JournalEntry(
      title: "First Journal Entry",
      content:
          "Today marks the beginning of my daily journaling journey. I'm excited to document my thoughts and experiences.",
      date: DateTime(2025, 10, 15),
    ),
    JournalEntry(
      title: "Reflections on Goals",
      content:
          "Setting clear goals for the month ahead. Focus on personal growth and staying consistent with daily habits.",
      date: DateTime(2025, 10, 16),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onNewEntry() async {
    final newEntry = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddJournalScreen(selectedDate: _selectedDay ?? DateTime.now()),
        fullscreenDialog: true,
      ),
    );

    if (newEntry != null && newEntry is JournalEntry) {
      setState(() {
        _allEntries.add(newEntry);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('All Entries'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _onNewEntry,
              tooltip: 'Add Entry for Selected Day',
            ),
          ],
        ),
        body: Column(
          children: [
            _buildCalendar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 1, color: Colors.white24),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: _allEntries
                    .where((entry) => isSameDay(entry.date, _selectedDay))
                    .map((entry) => JournalCard(entry: entry))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final theme = Theme.of(context);
    return TableCalendar(
      firstDay: DateTime(2025, 10, 15),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
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
