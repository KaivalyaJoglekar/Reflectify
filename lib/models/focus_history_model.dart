class FocusHistory {
  final String id;
  final int durationMinutes;
  final DateTime startTime;
  final DateTime endTime;
  final bool completed;

  FocusHistory({
    required this.id,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    required this.completed,
  });

  // Duration in minutes
  int get actualDuration => endTime.difference(startTime).inMinutes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'durationMinutes': durationMinutes,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'completed': completed,
    };
  }

  factory FocusHistory.fromJson(Map<String, dynamic> json) {
    return FocusHistory(
      id: json['id'] as String,
      durationMinutes: json['durationMinutes'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      completed: json['completed'] as bool,
    );
  }
}
