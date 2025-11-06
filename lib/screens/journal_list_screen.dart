import 'package:flutter/material.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/screens/add_journal_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/glass_card.dart';
import 'package:reflectify/widgets/journal_card.dart';

// Dummy data for demonstration
final List<JournalEntry> _dummyEntries = [
  JournalEntry(
    id: '1',
    title: 'Great Day at College',
    content:
        'Today was amazing. I finally finished my GRU threat detection model and the presentation went perfectly. Everyone was impressed.',
    date: DateTime.now().subtract(const Duration(days: 1)),
    mood: 'Great',
  ),
  JournalEntry(
    id: '2',
    title: 'Flutter Project Work',
    content:
        'Spent most of the day debugging the new Flutter app. The glassmorphism effect is tricky but it\'s starting to look really good. ',
    date: DateTime.now().subtract(const Duration(days: 2)),
    mood: 'Good',
  ),
  JournalEntry(
    id: '3',
    title: 'OS Exam',
    content:
        'Had the operating systems final. I think it went okay, but the question on Peterson\'s solution was tough. Just glad it\'s over.',
    date: DateTime.now().subtract(const Duration(days: 4)),
    mood: 'Okay',
  ),
];

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Today', 'This Week', 'This Month'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allow the background to draw behind the app bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Your Entries'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddJournalScreen()),
              );
            },
          ),
        ],
      ),
      // Use the new animated background
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildFilterChips(),
              const SizedBox(height: 24),
              ..._dummyEntries.map(
                (entry) => JournalCard(
                  entry: entry,
                  onTap: () {
                    // Handle tap
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      borderRadius: 16,
      child: SizedBox(
        height: 40,
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search entries...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ChoiceChip(
              label: Text(_filters[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              backgroundColor: Colors.black.withValues(alpha: 0.3),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.white24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
