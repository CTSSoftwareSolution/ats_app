import 'package:flutter/material.dart';

import '../../utilities/extension.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Appointment time over date, right-aligned (sits next to the plate on list
/// cards). Shows "Date not set" when [raw] isn't a parseable date.
class AppointmentTime extends StatelessWidget {
  /// Date string as returned by the API.
  final String raw;

  const AppointmentTime({super.key, required this.raw});

  @override
  Widget build(BuildContext context) {
    if (DateTime.tryParse(raw) == null) {
      return const Text('Date not set', style: AppText.caption);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatTime(raw),
          style: AppText.chip.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(formatDate(raw), style: AppText.caption),
      ],
    );
  }
}
