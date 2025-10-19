import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Checkbox(
          value: widget.task.isCompleted,
          onChanged: (bool? value) {
            setState(() {
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
        trailing: Text(
          // Use a dummy date for formatting as only the time is relevant
          DateFormat.jm().format(
            DateTime(
              2025,
              1,
              1,
              widget.task.time.hour,
              widget.task.time.minute,
            ),
          ),
          style: TextStyle(
            color: widget.task.isCompleted ? Colors.white54 : Colors.white,
          ),
        ),
      ),
    );
  }
}
