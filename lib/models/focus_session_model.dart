import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class FocusSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes; // Planned duration
  final int actualMinutes; // Actual duration completed
  final bool isCompleted;
  final String? taskId; // Optional associated task
  final String sessionType; // pomodoro, deep_work, break
  final String? notes;

  FocusSession({
    String? id,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 25, // Default Pomodoro
    this.actualMinutes = 0,
    this.isCompleted = false,
    this.taskId,
    this.sessionType = 'pomodoro',
    this.notes,
  }) : id = id ?? _uuid.v4();

  FocusSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    int? actualMinutes,
    bool? isCompleted,
    String? taskId,
    String? sessionType,
    String? notes,
  }) {
    return FocusSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      taskId: taskId ?? this.taskId,
      sessionType: sessionType ?? this.sessionType,
      notes: notes ?? this.notes,
    );
  }

  // Get total focus hours for a list of sessions
  static double getTotalHours(List<FocusSession> sessions) {
    return sessions.fold(
      0.0,
      (sum, session) => sum + (session.actualMinutes / 60),
    );
  }

  // Get completed sessions count
  static int getCompletedCount(List<FocusSession> sessions) {
    return sessions.where((s) => s.isCompleted).length;
  }
}
