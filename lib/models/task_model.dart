import 'package:flutter/material.dart';

class Task {
  final String title;
  final String time;
  final bool isCompleted;
  final Color color;
  final String projectName;
  final int taskCount;
  final String date;

  Task({
    required this.title,
    required this.time,
    this.isCompleted = false,
    required this.color,
    required this.projectName,
    required this.taskCount,
    required this.date,
  });
}