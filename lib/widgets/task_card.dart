// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final dynamic task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.primaryColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Checkbox(
          value: widget.task.isCompleted,
          onChanged: (bool? value) {
            setState(() {
              // Mutating a field in a model inside a stateful widget.
              // In Riverpod, this should be replaced by a call to TaskNotifier.
              widget.task.isCompleted = value!;
            });
          },
          activeColor: theme.primaryColor,
          checkColor: Colors.white,
          side: const BorderSide(color: Colors.white54),
        ),
        title: Text(
          widget.task.title,
          style: TextStyle(
            color: widget.task.isCompleted ? Colors.white54 : Colors.white,
            decoration: widget.task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        // FIX: Use the simple string time field
        trailing: Text(
          widget.task.time,
          style: TextStyle(
            color: widget.task.isCompleted ? Colors.white54 : Colors.white,
          ),
        ),
      ),
    );
  }
}
