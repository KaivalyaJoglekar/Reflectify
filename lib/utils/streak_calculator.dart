class StreakCalculator {
  // Mock data for streak - in production, this would come from database
  static Map<DateTime, int> generateStreakData() {
    final Map<DateTime, int> data = {};
    final startDate = DateTime(2025, 10, 15);
    final today = DateTime.now();
    final endDate = today.isAfter(startDate) ? today : startDate;

    // Generate activity data
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final date = startDate.add(Duration(days: i));
      // Randomly assign 0-5 entries per day (skip some days)
      if (i % 3 != 0) {
        data[DateTime(date.year, date.month, date.day)] = (i % 5) + 1;
      }
    }
    return data;
  }

  static int calculateCurrentStreak() {
    final streakData = generateStreakData();
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 100; i++) {
      final date = today.subtract(Duration(days: i));
      final key = DateTime(date.year, date.month, date.day);
      if (streakData.containsKey(key) && streakData[key]! > 0) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static int calculateLongestStreak() {
    final streakData = generateStreakData();
    int longestStreak = 0;
    int currentStreak = 0;

    final startDate = DateTime(2025, 10, 15);
    final today = DateTime.now();

    for (int i = 0; i <= today.difference(startDate).inDays; i++) {
      final date = startDate.add(Duration(days: i));
      final key = DateTime(date.year, date.month, date.day);

      if (streakData.containsKey(key) && streakData[key]! > 0) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
    }

    return longestStreak;
  }
}
