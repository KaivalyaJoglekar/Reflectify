import 'package:flutter/material.dart';
import 'dart:async';
import 'package:reflectify/models/focus_history_model.dart';

class FocusModeScreen extends StatefulWidget {
  final Function(FocusHistory)? onSessionComplete;
  final List<FocusHistory> history;

  const FocusModeScreen({
    super.key,
    this.onSessionComplete,
    this.history = const [],
  });

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  int _selectedMinutes = 25; // Pomodoro default
  int _remainingSeconds = 0;
  int _initialSeconds = 0; // Track the initial duration when timer starts
  bool _isRunning = false;
  bool _isPaused = false; // Track if timer is paused
  Timer? _timer;
  DateTime? _sessionStartTime;
  int _currentTab = 0; // 0 for timer, 1 for history

  final List<int> _presetMinutes = [15, 25, 45, 60];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      // Use custom time if set, otherwise use preset minutes
      if (_remainingSeconds == 0) {
        _remainingSeconds = _selectedMinutes * 60;
      }
      _initialSeconds = _remainingSeconds; // Store initial duration
      _sessionStartTime = DateTime.now();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _pauseTimer();
          _showCompletionDialog(true);
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true; // Mark as paused
    });
  }

  void _resumeTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _pauseTimer();
          _showCompletionDialog(true);
        }
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    final endTime = DateTime.now();
    final completed = _remainingSeconds == 0;

    // Save session history if it was started
    if (_sessionStartTime != null) {
      final durationMinutes = (_initialSeconds / 60).ceil();
      final session = FocusHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        durationMinutes: durationMinutes,
        durationSeconds: _initialSeconds,
        startTime: _sessionStartTime!,
        endTime: endTime,
        completed: completed,
      );
      widget.onSessionComplete?.call(session);
    }

    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = 0;
      _initialSeconds = 0;
      _sessionStartTime = null;
    });
  }

  void _showCompletionDialog(bool completed) {
    final endTime = DateTime.now();

    // Save completed session
    if (_sessionStartTime != null && completed) {
      final durationMinutes = (_initialSeconds / 60).ceil();
      final session = FocusHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        durationMinutes: durationMinutes,
        durationSeconds: _initialSeconds,
        startTime: _sessionStartTime!,
        endTime: endTime,
        completed: true,
      );
      widget.onSessionComplete?.call(session);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          '🎉 Focus Complete!',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Great job! You completed your focus session.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    setState(() {
      _sessionStartTime = null;
    });
  }

  void _showCustomTimeDialog() {
    final minutesController = TextEditingController();
    final secondsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Custom Duration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set your custom focus time',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                      labelStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: secondsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Seconds',
                      labelStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final seconds = int.tryParse(secondsController.text) ?? 0;

              final totalSeconds = (minutes * 60) + seconds;

              if (totalSeconds > 0) {
                setState(() {
                  _selectedMinutes = totalSeconds ~/ 60;
                  if (totalSeconds % 60 > 0) {
                    _selectedMinutes++;
                  }
                  _remainingSeconds = totalSeconds;
                  _isPaused = false; // Not paused, just custom time set
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid time'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(20), child: _buildHeader()),
            _buildTabs(),
            const SizedBox(height: 20),
            Expanded(
              child: _currentTab == 0 ? _buildTimerTab() : _buildHistoryTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentTab == 0
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Timer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentTab == 0 ? Colors.white : Colors.white70,
                    fontWeight: _currentTab == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentTab == 1
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'History',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentTab == 1 ? Colors.white : Colors.white70,
                    fontWeight: _currentTab == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).padding.bottom + 120, // Dynamic padding for navbar + nav buttons
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimer(),
          const SizedBox(height: 60),
          if (!_isRunning) _buildPresetButtons(),
          const SizedBox(height: 40),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (widget.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No focus sessions yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete a session to see your history',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom + 120, // Dynamic padding for navbar + nav buttons
      ),
      itemCount: widget.history.length,
      itemBuilder: (context, index) {
        final session = widget.history[widget.history.length - 1 - index];
        return _buildHistoryCard(session);
      },
    );
  }

  Widget _buildHistoryCard(FocusHistory session) {
    // Use durationSeconds if available, otherwise fall back to durationMinutes
    final totalSeconds =
        session.durationSeconds ?? (session.durationMinutes * 60);
    final hours = totalSeconds ~/ 3600;
    final mins = (totalSeconds % 3600) ~/ 60;
    final secs = totalSeconds % 60;

    String durationLabel;
    if (hours > 0) {
      durationLabel = '${hours}h ${mins}m ${secs}s session';
    } else if (mins > 0) {
      durationLabel = secs > 0
          ? '${mins}m ${secs}s session'
          : '${mins}m session';
    } else {
      durationLabel = '${secs}s session';
    }

    // Calculate actual focused time
    final actualDuration = session.endTime.difference(session.startTime);
    final actualHours = actualDuration.inHours;
    final actualMins = actualDuration.inMinutes % 60;
    final actualSecs = actualDuration.inSeconds % 60;

    String actualTimeLabel;
    if (actualHours > 0) {
      actualTimeLabel = '${actualHours}h ${actualMins}m ${actualSecs}s';
    } else if (actualMins > 0) {
      actualTimeLabel = '${actualMins}m ${actualSecs}s';
    } else {
      actualTimeLabel = '${actualSecs}s';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: session.completed
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: session.completed
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              session.completed ? Icons.check_circle : Icons.cancel,
              color: session.completed ? Colors.green : Colors.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  durationLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(session.startTime)} • ${_formatTimeOnly(session.startTime)} - ${_formatTimeOnly(session.endTime)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      session.completed ? 'Completed' : 'Stopped early',
                      style: TextStyle(
                        fontSize: 12,
                        color: session.completed ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• Focused: $actualTimeLabel',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Today';
    } else if (sessionDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTimeOnly(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Focus Mode',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'BebasNeue',
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Stay focused, stay productive',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1C1C1E),
                title: const Text(
                  'Focus Mode Tips',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  '• Choose a duration\n'
                  '• Eliminate distractions\n'
                  '• Focus on one task\n'
                  '• Take breaks between sessions',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.3),
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRunning
                  ? _formatTime(_remainingSeconds)
                  : _formatTime(
                      _remainingSeconds > 0
                          ? _remainingSeconds
                          : _selectedMinutes * 60,
                    ),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'BebasNeue',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isRunning ? 'Stay Focused' : 'Ready to Focus',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButtons() {
    final allButtons = [
      ..._presetMinutes.map((minutes) {
        final isSelected = minutes == _selectedMinutes;
        final hours = minutes ~/ 60;
        final mins = minutes % 60;
        final timeLabel = hours > 0 ? '${hours}h ${mins}m' : '${mins}m';

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMinutes = minutes;
              _remainingSeconds = 0; // Reset display
              _isPaused = false; // Reset paused state
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              timeLabel,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        );
      }),
      GestureDetector(
        onTap: _showCustomTimeDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Custom',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: allButtons,
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isRunning) ...[
          _buildControlButton(
            icon: Icons.stop,
            label: 'Stop',
            onPressed: _resetTimer,
            color: Colors.red,
          ),
          const SizedBox(width: 20),
          _buildControlButton(
            icon: Icons.pause,
            label: 'Pause',
            onPressed: _pauseTimer,
            color: Colors.orange,
          ),
        ] else ...[
          _buildControlButton(
            icon: Icons.play_arrow,
            label: _isPaused ? 'Resume' : 'Start',
            onPressed: _isPaused ? _resumeTimer : _startTimer,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
