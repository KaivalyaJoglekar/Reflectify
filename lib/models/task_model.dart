import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // ADDED: The missing import for Uuid

const _uuid = Uuid();

class Task {
  final String id;
  final String title;
  final String time;
  final bool isCompleted;
  final Color color;
  final String projectName;
  final int taskCount;
  final DateTime date;
  final String description;
  final String category; // Work, Personal, Projects, etc.
  final int priority; // 1 (high), 2 (medium), 3 (low)
  final DateTime? deadline;
  final List<String> tags;
  final int orderIndex; // For drag-and-drop ordering
  final bool hasReminder;
  final DateTime? reminderTime;

  Task({
    String? id,
    required this.title,
    required this.time,
    this.isCompleted = false,
    required this.color,
    required this.projectName,
    required this.taskCount,
    required this.date,
    this.description = '',
    this.category = 'Personal',
    this.priority = 2,
    this.deadline,
    this.tags = const [],
    this.orderIndex = 0,
    this.hasReminder = false,
    this.reminderTime,
  }) : id = id ?? _uuid.v4();

  Task copyWith({
    String? id,
    String? title,
    String? time,
    bool? isCompleted,
    Color? color,
    String? projectName,
    int? taskCount,
    DateTime? date,
    String? description,
    String? category,
    int? priority,
    DateTime? deadline,
    List<String>? tags,
    int? orderIndex,
    bool? hasReminder,
    DateTime? reminderTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      projectName: projectName ?? this.projectName,
      taskCount: taskCount ?? this.taskCount,
      date: date ?? this.date,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      tags: tags ?? this.tags,
      orderIndex: orderIndex ?? this.orderIndex,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
