import 'package:ats_app/widgets/new_app_ui/status_badge.dart';
import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import 'app_progress_bar.dart';

class CaptureProgressHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int done;
  final int total;
  final String? trailingLabel;

  const CaptureProgressHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.total,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final complete = total > 0 && done >= total;
    final progress = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
    return Container(
      color: surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.page,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.sectionTitle),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      style: AppText.caption.copyWith(color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              complete
                  ? StatusBadge.pass(label: trailingLabel ?? '$done/$total')
                  : StatusBadge(
                      label: trailingLabel ?? '$done/$total',
                      color: appColor,
                      background: accentLight,
                    ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar.thick(value: progress),
        ],
      ),
    );
  }
}
