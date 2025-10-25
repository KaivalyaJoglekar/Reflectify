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

  Task({
    String? id,
    required this.title,
    required this.time,
    this.isCompleted = false,
    required this.color,
    required this.projectName,
    required this.taskCount,
    required this.date,
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
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
