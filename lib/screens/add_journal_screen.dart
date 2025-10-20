import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reflectify/models/journal_entry.dart';

class AddJournalScreen extends StatefulWidget {
  final DateTime selectedDate;
  const AddJournalScreen({super.key, required this.selectedDate});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DateTime _currentDate;
  late TimeOfDay _currentTime;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
    _currentTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentTime) {
      setState(() {
        _currentTime = picked;
      });
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      final finalDateTime = DateTime(
        _currentDate.year,
        _currentDate.month,
        _currentDate.day,
        _currentTime.hour,
        _currentTime.minute,
      );

      final newEntry = JournalEntry(
        title: _titleController.text,
        content: _contentController.text,
        date: finalDateTime,
      );
      Navigator.of(context).pop(newEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
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
              _buildDateTimePicker(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title your reflection...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 24),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your journal content'
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              DateFormat.yMMMd().format(_currentDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.access_time_filled, color: Colors.white70),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _selectTime(context),
              child: Text(
                _currentTime.format(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}