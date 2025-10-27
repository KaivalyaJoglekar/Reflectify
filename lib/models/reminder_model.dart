import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Reminder {
  final String id;
  final String taskId;
  final DateTime reminderTime;
  final bool isRecurring;
  final String? recurrencePattern; // daily, weekly, monthly
  final bool isActive;
  final bool hasBeenTriggered;
  final DateTime createdAt;

  Reminder({
    String? id,
    required this.taskId,
    required this.reminderTime,
    this.isRecurring = false,
    this.recurrencePattern,
    this.isActive = true,
    this.hasBeenTriggered = false,
    DateTime? createdAt,
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now();

  Reminder copyWith({
    String? id,
    String? taskId,
    DateTime? reminderTime,
    bool? isRecurring,
    String? recurrencePattern,
    bool? isActive,
    bool? hasBeenTriggered,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      reminderTime: reminderTime ?? this.reminderTime,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      isActive: isActive ?? this.isActive,
      hasBeenTriggered: hasBeenTriggered ?? this.hasBeenTriggered,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
