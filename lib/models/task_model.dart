import 'package:flutter/material.dart';

class Task {
  String title;
  TimeOfDay time;
  bool isCompleted;

  Task({required this.title, required this.time, this.isCompleted = false});
}
