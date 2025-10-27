import 'package:flutter/material.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/widgets/journal_card.dart';
import 'package:reflectify/screens/add_journal_screen.dart';

class JournalListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  const JournalListScreen({super.key, this.tasks = const []});

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
                children: [
                  // Journal entries for selected day
                  ..._allEntries
                      .where((entry) => isSameDay(entry.date, _selectedDay))
                      .map((entry) => JournalCard(entry: entry)),
                  // Tasks for selected day
                  ...widget.tasks
                      .where((task) {
                        final taskDate = task['createdAt'] as DateTime?;
                        return taskDate != null &&
                            isSameDay(taskDate, _selectedDay);
                      })
                      .map((task) => _buildTaskCard(task)),
                ],
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

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final taskDate = task['createdAt'] as DateTime?;
    final timeString = taskDate != null
        ? '${taskDate.hour.toString().padLeft(2, '0')}:${taskDate.minute.toString().padLeft(2, '0')}'
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8A5DF4).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                task['completed'] == true
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: const Color(0xFF8A5DF4),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (timeString.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A5DF4).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    timeString,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A5DF4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          if (task['description'] != null &&
              task['description'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 32),
              child: Text(
                task['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
