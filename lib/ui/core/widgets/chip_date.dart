import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../colors/app_colors.dart';

class ChipDate extends StatelessWidget {
  const ChipDate({
    super.key,
    required this.dateTime,
  });

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final meetingDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final String label;
    final Color color;

    if (meetingDate == today) {
      label = 'HOJE';
      color = AppColors.success;
    } else if (meetingDate == tomorrow) {
      label = 'AMANHÃ';
      color = AppColors.info;
    } else {
      label = DateFormat('dd/MM').format(dateTime);
      color = colorScheme.outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withValues(alpha: 0.9),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
