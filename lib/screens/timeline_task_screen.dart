import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:reflectify/models/task_model.dart';
import 'package:intl/intl.dart';

class TimelineTaskScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskComplete;
  final Function(Task) onTaskDelete;
  final Function(Task) onTaskEdit;

  const TimelineTaskScreen({
    super.key,
    required this.tasks,
    required this.onTaskComplete,
    required this.onTaskDelete,
    required this.onTaskEdit,
  });

  @override
  State<TimelineTaskScreen> createState() => _TimelineTaskScreenState();
}

class _TimelineTaskScreenState extends State<TimelineTaskScreen> {
  late DateTime _selectedDate;
  late ScrollController _timelineController;
  late ScrollController _dateController;
  final List<DateTime> _weekDates = [];
  String _selectedFilter = 'Active';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _timelineController = ScrollController();
    _dateController = ScrollController();
    _generateWeekDates();
  }

  void _generateWeekDates() {
    final now = DateTime.now();
    for (int i = -3; i <= 3; i++) {
      _weekDates.add(now.add(Duration(days: i)));
    }
  }

  @override
  void dispose() {
    _timelineController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildFilterSegments(),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 24),
            Expanded(child: _build24HourTimeline()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4285F4),
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            DateFormat('EEEE, d MMMM y').format(_selectedDate),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 75,
          child: ListView.builder(
            controller: _dateController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _weekDates.length,
            itemBuilder: (context, index) {
              final date = _weekDates[index];
              final isSelected = DateUtils.isSameDay(date, _selectedDate);
              return _buildDateCylinder(date, isSelected);
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey[600],
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildDateCylinder(DateTime date, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4285F4) : const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build24HourTimeline() {
    return ListView.builder(
      controller: _timelineController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 24,
      itemBuilder: (context, hour) {
        final timeString = '${hour.toString().padLeft(2, '0')}:00';
        final tasksAtHour = widget.tasks.where((task) {
          final taskHour = int.parse(task.time.split(':')[0]);
          final matchesDate = DateUtils.isSameDay(task.date, _selectedDate);
          final matchesFilter =
              _selectedFilter == 'All' ||
              (_selectedFilter == 'Active' && !task.isCompleted) ||
              (_selectedFilter == 'Completed' && task.isCompleted);
          return taskHour == hour && matchesDate && matchesFilter;
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Time marker
                  Row(
                    children: [
                      SizedBox(
                        width: 45,
                        child: Text(
                          timeString,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Container(width: 15, height: 1, color: Colors.grey[700]),
                    ],
                  ),
                  Expanded(
                    child: Container(height: 1, color: Colors.grey[900]),
                  ),
                ],
              ),
              if (tasksAtHour.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...tasksAtHour.map((task) => _buildTimelineTaskCard(task)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(left: 60),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: task.color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (task.hasReminder)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.videocam,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ),
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                task.time,
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              // Example participant avatars - replace with actual data
              for (int i = 0; i < 4; i++)
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                ),
              if (task.category.isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: task.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.category,
                    style: TextStyle(fontSize: 12, color: task.color),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    // TODO: Implement task creation dialog
  }

  Widget _buildFilterSegments() {
    final filters = ['All', 'Active', 'Completed'];
    final selectedIndex = filters.indexOf(_selectedFilter);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // outer rounded border/background
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF4285F4), width: 1),
              ),
            ),

            // animated glass pill (frosted glass effect)
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: Alignment((selectedIndex - 1).toDouble(), 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 140,
                    height: 40,
                    decoration: BoxDecoration(
                      // subtle translucent white for glass; tint with blue border glow
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF4285F4).withOpacity(0.15),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4285F4).withOpacity(0.06),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // labels row (transparent backgrounds)
            Row(
              children: [
                for (int i = 0; i < filters.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filters[i]),
                      child: SizedBox(
                        height: 48,
                        child: Center(
                          child: Text(
                            filters[i],
                            style: TextStyle(
                              color: _selectedFilter == filters[i]
                                  ? Colors.white
                                  : Colors.grey[400],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
