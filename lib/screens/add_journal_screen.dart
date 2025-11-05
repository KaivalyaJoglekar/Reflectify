// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/glass_card.dart';
import 'package:reflectify/models/journal_entry.dart';
import 'package:intl/intl.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedMood = 'neutral';
  bool _isFavorite = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something about your day'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final entry = JournalEntry(
      title: _titleController.text.trim().isEmpty
          ? 'Journal Entry - ${DateFormat('MMM d').format(DateTime.now())}'
          : _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: DateTime.now(),
      mood: _selectedMood,
      isFavorite: _isFavorite,
    );

    Navigator.of(context).pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfWeek = DateFormat('EEEE').format(now);
    final date = DateFormat('MMMM d, yyyy').format(now);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('New Journal Entry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            tooltip: 'Add to favorites',
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // Date Header
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayOfWeek,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mood Selector
              _buildMoodSelector(),
              const SizedBox(height: 24),

              // Title (Optional)
              GlassCard(
                padding: EdgeInsets.zero,
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title (optional)',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.normal,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Content
              const Text(
                'How was your day?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: EdgeInsets.zero,
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white, height: 1.6),
                  maxLines: 12,
                  minLines: 8,
                  decoration: InputDecoration(
                    hintText:
                        'Jot down your thoughts, feelings, and experiences...\n\nWhat made you smile today?\nWhat challenges did you face?\nWhat are you grateful for?',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: _saveEntry,
                child: const Text(
                  'Save Entry',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 100), // Extra padding for bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodIcon(
                'sad',
                Icons.sentiment_very_dissatisfied,
                const Color(0xFF6C8EBF),
              ),
              _buildMoodIcon(
                'anxious',
                Icons.sentiment_dissatisfied,
                const Color(0xFFD62F6D),
              ),
              _buildMoodIcon('neutral', Icons.sentiment_neutral, Colors.grey),
              _buildMoodIcon(
                'calm',
                Icons.self_improvement,
                const Color(0xFF8A5DF4),
              ),
              _buildMoodIcon(
                'happy',
                Icons.sentiment_very_satisfied,
                const Color(0xFF06D6A0),
              ),
              _buildMoodIcon(
                'excited',
                Icons.celebration,
                const Color(0xFFF4A261),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(String mood, IconData icon, Color color) {
    final isSelected = _selectedMood == mood;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: color, width: 2)
              : Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? color : Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 4),
            Text(
              mood.capitalize(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
