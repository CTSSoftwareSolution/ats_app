import 'package:flutter/material.dart';

import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';

/// Small status pill used on category headers (Pass / Fail / Partial / Pending).
/// Same shape and type as a dense [StatusBadge], for callers that supply
/// their own colour.
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  /// Optional fill; defaults to a light tint of [color].
  final Color? background;
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: AppText.badgeDense.copyWith(color: color),
      ),
    );
  }
}
