import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class JournalEntry {
  final String id;
  String title;
  String content;
  DateTime date;
  final List<String> tags;
  final String mood; // happy, sad, neutral, excited, etc.
  bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.content,
    required this.date,
    this.tags = const [],
    this.mood = 'neutral',
    this.isFavorite = false,
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
    bool? isFavorite,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
