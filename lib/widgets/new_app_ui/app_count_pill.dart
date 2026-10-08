import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Brand-tinted count next to a list title ("Appointments [134]").
class AppCountPill extends StatelessWidget {
  final int count;

  const AppCountPill({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: accentLight,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '$count',
        maxLines: 1,
        style: AppText.tag.copyWith(
          color: appColor,
          fontFeatures: AppText.tabular,
        ),
      ),
    );
  }
}
