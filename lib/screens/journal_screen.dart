import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  final DateTime selectedDate;
  const JournalScreen({super.key, required this.selectedDate});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      final newEntry = JournalEntry(
        title: _titleController.text,
        content: _contentController.text,
        date: widget.selectedDate,
      );
      Navigator.of(context).pop(newEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Journal Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveEntry,
            tooltip: 'Save Entry',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your journal content';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}