import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const _uuid = Uuid();

enum ProjectStatus { todo, inProgress, done }

class Project {
  final String id;
  final String name;
  final String description;
  final Color color;
  final DateTime createdAt;
  final DateTime? deadline;
  final List<String> taskIds; // References to associated tasks
  final ProjectStatus status;
  final int progress; // 0-100
  final List<String> milestones;

  Project({
    String? id,
    required this.name,
    this.description = '',
    required this.color,
    DateTime? createdAt,
    this.deadline,
    this.taskIds = const [],
    this.status = ProjectStatus.todo,
    this.progress = 0,
    this.milestones = const [],
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now();

  Project copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    DateTime? createdAt,
    DateTime? deadline,
    List<String>? taskIds,
    ProjectStatus? status,
    int? progress,
    List<String>? milestones,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      taskIds: taskIds ?? this.taskIds,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      milestones: milestones ?? this.milestones,
    );
  }
}
