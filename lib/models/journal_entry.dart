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

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'tags': tags,
      'mood': mood,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON for Firebase
  factory JournalEntry.fromJson(Map<dynamic, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      mood: json['mood'] as String? ?? 'neutral',
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}
