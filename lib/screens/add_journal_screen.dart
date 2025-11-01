import 'package:flutter/material.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/glass_card.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  String _selectedMood = 'Okay';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('New Entry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              const Text(
                'How was your day?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildMoodSelector(),
              const SizedBox(height: 24),
              _buildJournalTextField(),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Save logic
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Save Entry',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
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
            'Select your mood',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodIcon('Awful', Icons.sentiment_very_dissatisfied),
              _buildMoodIcon('Bad', Icons.sentiment_dissatisfied),
              _buildMoodIcon('Okay', Icons.sentiment_neutral),
              _buildMoodIcon('Good', Icons.sentiment_satisfied),
              _buildMoodIcon('Great', Icons.sentiment_very_satisfied),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(String mood, IconData icon) {
    final isSelected = _selectedMood == mood;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              mood,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalTextField() {
    return GlassCard(
      // Remove padding from the card
      padding: EdgeInsets.zero,
      child: TextField(
        style: const TextStyle(color: Colors.white, height: 1.6),
        maxLines: 15,
        minLines: 10,
        decoration: const InputDecoration(
          hintText: 'Write about your day, your thoughts, or your tasks...',
          hintStyle: TextStyle(color: Colors.white54),
          // Add padding inside the text field
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none, // Remove all borders
        ),
      ),
    );
  }
}
