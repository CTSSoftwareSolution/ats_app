import 'package:flutter/material.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/new_app_ui/app_icon_tile.dart';
import '../../../../widgets/new_app_ui/app_progress_bar.dart';
import '../../../provider/inspection_form_provider.dart';

/// Section overview at the top of a tab: name, progress and a
/// Pass / Fail / Pending tally so the inspector sees the result at a glance.
class SectionSummaryCard extends StatelessWidget {
  final SectionState section;
  const SectionSummaryCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final complete = section.isComplete && section.totalQuestions > 0;
    int passCount = 0, failCount = 0;
    for (final c in section.categories) {
      for (final q in c.questions) {
        if (q.answer == AnswerState.Pass) passCount++;
        if (q.answer == AnswerState.Fail) failCount++;
      }
    }
    final pending = section.totalQuestions - section.totalAnswered;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section identity: the section's own icon in the brand colour
              // (a tick once complete). Matters most in Under-PIT mode, where
              // there is no tab strip naming the section.
              AppIconTile(
                icon: complete ? Icons.task_alt_rounded : section.icon,
                color: complete ? pass : appColor,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(section.label, style: AppText.sectionTitle),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${section.categories.length} categories · ${section.totalQuestions} checks'
                      '${section.subtitle.isNotEmpty ? ' · ${section.subtitle}' : ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '${(section.overallProgress * 100).toStringAsFixed(0)}%',
                style: AppText.pageTitle.copyWith(
                  color: complete ? pass : textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar.thick(
            value: section.overallProgress,
            color: complete ? pass : appColor,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _Tally(label: 'Pass', value: passCount, color: pass),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _Tally(label: 'Fail', value: failCount, color: fail),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _Tally(label: 'Pending', value: pending, color: na),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tally extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _Tally({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$value $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: value > 0 ? color.withValues(alpha: 0.08) : surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Text(
              '$value',
              style: AppText.sectionTitle.copyWith(
                color: value > 0 ? color : textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.iconGap),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(color: value > 0 ? color : na),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
