class DailySummary {
  final DateTime date;
  final int tasksCompleted;
  final int totalTasks;
  final int focusMinutes;
  final String mood;
  final List<String> notes;
  final List<String> achievements;

  DailySummary({
    required this.date,
    this.tasksCompleted = 0,
    this.totalTasks = 0,
    this.focusMinutes = 0,
    this.mood = 'neutral',
    this.notes = const [],
    this.achievements = const [],
  });

  double get completionRate =>
      totalTasks > 0 ? (tasksCompleted / totalTasks) * 100 : 0;

  DailySummary copyWith({
    DateTime? date,
    int? tasksCompleted,
    int? totalTasks,
    int? focusMinutes,
    String? mood,
    List<String>? notes,
    List<String>? achievements,
  }) {
    return DailySummary(
      date: date ?? this.date,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      totalTasks: totalTasks ?? this.totalTasks,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
      achievements: achievements ?? this.achievements,
    );
  }
}
