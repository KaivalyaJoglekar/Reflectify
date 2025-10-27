import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:reflectify/models/focus_session_model.dart';

class FocusModeScreen extends StatefulWidget {
  final List<FocusSession> sessions;
  final Function(FocusSession) onSessionComplete;

  const FocusModeScreen({
    super.key,
    this.sessions = const [],
    required this.onSessionComplete,
  });

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  Timer? _timer;
  int _remainingSeconds = 25 * 60; // 25 minutes default
  int _selectedDuration = 25;
  bool _isRunning = false;
  bool _isPaused = false;
  FocusSession? _currentSession;

  final List<int> _durations = [15, 25, 45, 60];
  final List<String> _ambientSounds = [
    'None',
    'Rain',
    'Ocean',
    'Forest',
    'Cafe',
  ];
  String _selectedSound = 'None';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _currentSession = FocusSession(
        startTime: DateTime.now(),
        durationMinutes: _selectedDuration,
        sessionType: 'pomodoro',
      );
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _completeSession();
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
  }

  void _resumeTimer() {
    setState(() {
      _isPaused = false;
    });
    _startTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = _selectedDuration * 60;
    });
  }

  void _completeSession() {
    _timer?.cancel();

    final completedSession = _currentSession!.copyWith(
      endTime: DateTime.now(),
      actualMinutes: _selectedDuration,
      isCompleted: true,
    );

    widget.onSessionComplete(completedSession);

    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = _selectedDuration * 60;
    });

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          '🎉 Session Complete!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Great job! You completed a $_selectedDuration minute focus session.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSessions = widget.sessions;
    final completedSessions = totalSessions.where((s) => s.isCompleted).length;
    final totalHours = FocusSession.getTotalHours(totalSessions);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildTimer(),
              const SizedBox(height: 32),
              if (!_isRunning) _buildDurationSelector(),
              if (!_isRunning) const SizedBox(height: 24),
              _buildControls(),
              const SizedBox(height: 32),
              if (!_isRunning) _buildAmbientSoundSelector(),
              if (!_isRunning) const SizedBox(height: 32),
              _buildStats(completedSessions, totalHours),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Focus Mode',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showInfoDialog(),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final progress = 1 - (_remainingSeconds / (_selectedDuration * 60));

    return CircularPercentIndicator(
      radius: 140,
      lineWidth: 16,
      percent: progress,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isRunning ? (_isPaused ? 'Paused' : 'Focus Time') : 'Ready',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
      progressColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white.withOpacity(0.1),
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animateFromLastPercent: true,
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Session Duration',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _durations.map((duration) {
            final isSelected = duration == _selectedDuration;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDuration = duration;
                  _remainingSeconds = duration * 60;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${duration}m',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isRunning) ...[
          ElevatedButton.icon(
            onPressed: _isPaused ? _resumeTimer : _pauseTimer,
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(_isPaused ? 'Resume' : 'Pause'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _stopTimer,
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ] else
          ElevatedButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.play_arrow, size: 28),
            label: const Text('Start Focus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAmbientSoundSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ambient Sound',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _ambientSounds.length,
            itemBuilder: (context, index) {
              final sound = _ambientSounds[index];
              final isSelected = sound == _selectedSound;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSound = sound;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getSoundIcon(sound),
                        size: 20,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        sound,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStats(int completedSessions, double totalHours) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Productivity Stats',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Sessions',
                '$completedSessions',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatItem(
                'Total Hours',
                totalHours.toStringAsFixed(1),
                Icons.timer,
                Colors.blue,
              ),
              _buildStatItem(
                'Streak',
                '${_calculateStreak()}',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }

  int _calculateStreak() {
    // Simple streak calculation based on consecutive days with sessions
    if (widget.sessions.isEmpty) return 0;

    final now = DateTime.now();
    int streak = 0;
    DateTime checkDate = now;

    while (true) {
      final hasSessionOnDate = widget.sessions.any((session) {
        final sessionDate = session.startTime;
        return sessionDate.year == checkDate.year &&
            sessionDate.month == checkDate.month &&
            sessionDate.day == checkDate.day;
      });

      if (hasSessionOnDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  IconData _getSoundIcon(String sound) {
    switch (sound) {
      case 'Rain':
        return Icons.water_drop;
      case 'Ocean':
        return Icons.waves;
      case 'Forest':
        return Icons.park;
      case 'Cafe':
        return Icons.coffee;
      default:
        return Icons.volume_off;
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          'Focus Mode Tips',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '• Choose a comfortable duration\n'
          '• Eliminate distractions\n'
          '• Take breaks between sessions\n'
          '• Use ambient sounds to stay focused\n'
          '• Track your progress over time',
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
