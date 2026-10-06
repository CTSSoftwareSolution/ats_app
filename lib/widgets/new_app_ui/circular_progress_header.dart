import 'package:ats_app/widgets/new_app_ui/status_badge.dart';
import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_text.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.sectionTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppText.caption.copyWith(color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              complete
                  ? StatusBadge.pass(label: trailingLabel ?? '$done/$total')
                  : StatusBadge(
                label: trailingLabel ?? '$done/$total',
                color: appColor,
                background: accentLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: surface2,
              valueColor: AlwaysStoppedAnimation<Color>(complete ? pass : appColor),
            ),
          ),
        ],
      ),
    );
  }
}