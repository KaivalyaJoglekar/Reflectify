import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              const Text(
                'Monday, 15th September 2021',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildWeekView(),
              const SizedBox(height: 24),
              Expanded(child: _buildTimeline()),
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
        IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
        IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
      ],
    );
  }

  Widget _buildWeekView() {
    // This is a simplified, static week view
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DateChip(day: 'MON', date: '15', isSelected: true),
        _DateChip(day: 'TUE', date: '16'),
        _DateChip(day: 'WED', date: '17'),
        _DateChip(day: 'THU', date: '18'),
        _DateChip(day: 'FRI', date: '19'),
      ],
    );
  }

  Widget _buildTimeline() {
    // A scrollable list of timeline events
    return ListView(
      children: const [
        TimelineEvent(
          time: '7 am',
          eventTitle: 'Morning training with Anna',
          eventTime: '7:00 am - 8:30 am',
          color: Colors.orange,
        ),
        TimelineEvent(
          time: '9 am',
          eventTitle: 'Team meeting (Front and Back)',
          eventTime: '9:20 am - 11:15 am',
          color: Colors.pink,
          isMultiLine: true,
        ),
        TimelineEvent(
          time: '12 am',
          eventTitle: 'Call Nikita about buying a car',
          eventTime: '12:10 am - 12:30 am',
          color: Colors.green,
        ),
      ],
    );
  }
}

// Widget for the date chips in the week view
class _DateChip extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;

  const _DateChip({
    required this.day,
    required this.date,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 60,
      width: 50,
      borderRadius: BorderRadius.circular(16),
      color: isSelected
          ? Theme.of(context).primaryColor
          : Colors.white.withOpacity(0.05),
      borderColor: isSelected
          ? Colors.transparent
          : Colors.white.withOpacity(0.2),
      blur: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for a single event in the timeline
class TimelineEvent extends StatelessWidget {
  final String time;
  final String eventTitle;
  final String eventTime;
  final Color color;
  final bool isMultiLine;

  const TimelineEvent({
    Key? key,
    required this.time,
    required this.eventTitle,
    required this.eventTime,
    required this.color,
    this.isMultiLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Text(time, style: TextStyle(color: Colors.grey[400])),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassContainer(
                height: isMultiLine ? 80 : 60,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.05),
                borderColor: Colors.white.withOpacity(0.2),
                blur: 15,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: isMultiLine ? 60 : 40,
                      color: color,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eventTime,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
