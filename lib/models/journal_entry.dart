import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class JournalEntry {
  final String id;
  String title;
  String content;
  DateTime date;
  final List<String> tags;
  final String mood; // happy, sad, neutral, excited, etc.
  final bool isMilestone;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.content,
    required this.date,
    this.tags = const [],
    this.mood = 'neutral',
    this.isMilestone = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    List<String>? tags,
    String? mood,
    bool? isMilestone,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
      isMilestone: isMilestone ?? this.isMilestone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
