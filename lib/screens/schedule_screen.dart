import 'package:flutter/material.dart';
import 'package:reflectify/widgets/timeline_event_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make background transparent
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildWeekView(context),
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
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
        ),
        IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
      ],
    );
  }

  Widget _buildWeekView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateChip(context, 'MON', '15', isSelected: true),
        _buildDateChip(context, 'TUE', '16'),
        _buildDateChip(context, 'WED', '17'),
        _buildDateChip(context, 'THU', '18'),
        _buildDateChip(context, 'FRI', '19'),
      ],
    );
  }

  Widget _buildDateChip(
    BuildContext context,
    String day,
    String date, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return ListView(
      children: const [
        TimelineEventCard(
          time: '7 am',
          eventTitle: 'Morning training with Anna',
          eventTime: '7:00 am - 8:30 am',
          color: Colors.orange,
        ),
        TimelineEventCard(
          time: '9 am',
          eventTitle: 'Team meeting (Front and Back)',
          eventTime: '9:20 am - 11:15 am',
          color: Colors.pink,
          isFloating: true,
        ),
        TimelineEventCard(
          time: '12 am',
          eventTitle: 'Call Nikita about buying a car',
          eventTime: '12:10 am - 12:30 am',
          color: Colors.green,
        ),
      ],
    );
  }
}
