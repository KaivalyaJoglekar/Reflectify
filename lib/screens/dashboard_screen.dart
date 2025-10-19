import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:reflectify/screens/add_journal_screen.dart';
import 'package:reflectify/screens/profile_screen.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/journal_card.dart';
import '../models/user_model.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for demonstration
  final List<JournalEntry> _recentEntries = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            children: [
              _buildAppBar(context),
              const SizedBox(height: 24),
              _buildNewEntryCard(context),
              const SizedBox(height: 32),
              _buildSectionHeader(context, 'Recent Entries'),
              const SizedBox(height: 16),
              ..._recentEntries.map((entry) => JournalCard(entry: entry)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good afternoon,',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.user.name.split(' ')[0],
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontSize: 28),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.person_outline_rounded, size: 30),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileScreen(user: widget.user),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewEntryCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AddJournalScreen(selectedDate: DateTime.now()),
                  fullscreenDialog: true,
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "What's on your mind?",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
    );
  }
}
