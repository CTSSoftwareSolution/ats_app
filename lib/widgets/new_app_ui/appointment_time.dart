import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ats_app/utilities/new_app_theme/app_spacing.dart';

import '../../utilities/color_data.dart';
import '../../utilities/extension.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Appointment time over a short, relative date ("Today", "Tomorrow",
/// "Yesterday", "6 Oct", "6 Oct 2025"), right-aligned next to the plate on
/// list cards. Today's appointments are highlighted in the brand colour.
/// Shows "Date not set" when [raw] isn't a parseable date.
class AppointmentTime extends StatelessWidget {
  /// Date string as returned by the API.
  final String raw;

  /// Reference time for "Today"/"Tomorrow"; defaults to now (for tests).
  final DateTime? now;

  const AppointmentTime({super.key, required this.raw, this.now});

  /// "Today", "Tomorrow", "Yesterday", "6 Oct" or "6 Oct 2025".
  static String relativeDate(DateTime date, DateTime now) {
    final day = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    switch (day.difference(today).inDays) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case -1:
        return 'Yesterday';
    }
    return DateFormat(date.year == now.year ? 'd MMM' : 'd MMM y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(raw);
    if (date == null) {
      return const Text('Date not set', style: AppText.caption);
    }
    final label = relativeDate(date, now ?? DateTime.now());
    final isToday = label == 'Today';
    return Semantics(
      label: 'Appointment $label at ${formatTime(raw)}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatTime(raw),
            style: AppText.chip.copyWith(fontFeatures: AppText.tabular),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: isToday
                ? AppText.tag.copyWith(color: appColor)
                : AppText.caption,
          ),
        ],
      ),
    );
  }
}
