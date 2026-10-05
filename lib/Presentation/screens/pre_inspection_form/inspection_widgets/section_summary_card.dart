import 'package:flutter/material.dart';
import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../provider/inspection_form_provider.dart';

class SectionSummaryCard extends StatelessWidget {
  final SectionState section;
  const SectionSummaryCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final complete = section.isComplete && section.totalQuestions > 0;
    final percent = (section.overallProgress * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.page, AppSpacing.lg, AppSpacing.page, AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(section.icon, color: appColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section.label, style: AppText.sectionTitle),
                    if (section.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        section.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(color: textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${section.totalAnswered}/${section.totalQuestions}',
                    style: AppText.pageTitle.copyWith(
                      color: complete ? pass : textPrimary,
                    ),
                  ),
                  const Text('Completed', style: AppText.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: section.overallProgress,
              backgroundColor: surface2,
              valueColor: AlwaysStoppedAnimation<Color>(complete ? pass : appColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${section.categories.length} categories',
                style: AppText.caption,
              ),
              Text(
                '$percent% done',
                style: AppText.caption.copyWith(
                  color: complete ? pass : textSecondary,
                  fontFamily: "SemiBold",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
