import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChipDate extends StatelessWidget {
  const ChipDate({
    super.key,
    required this.dateTime,
  });

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final meetingDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final String label;
    final Color color;

    if (meetingDate == today) {
      label = 'HOJE';
      color = Colors.green;
    } else if (meetingDate == tomorrow) {
      label = 'AMANHÃ';
      color = Colors.blue;
    } else if (meetingDate.isBefore(today)) {
      label = 'PASSADO';
      color = Colors.grey;
    } else {
      label = DateFormat('dd/MM').format(dateTime);
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withOpacity(0.9),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
