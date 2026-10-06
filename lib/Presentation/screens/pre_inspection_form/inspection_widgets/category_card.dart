import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/question_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/new_app_ui/status_badge.dart';
import '../../../provider/inspection_form_provider.dart';
import 'inspection_view_rules.dart';

/// Collapsible group of questions. The header shows the category result and
/// a pass / fail / remaining breakdown; the body lists the questions that
/// match the active filter.
class CategoryCard extends StatelessWidget {
  final int sectionIndex;
  final int categoryIndex;

  const CategoryCard({
    super.key,
    required this.sectionIndex,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        final section = provider.visibleSections[sectionIndex];
        final cat = section.categories[categoryIndex];

        // Questions to show, keeping their real index in the category.
        final shown = [
          for (var i = 0; i < cat.questions.length; i++)
            if (matchesQuestionFilter(cat.questions[i], provider.filter)) i,
        ];
        if (shown.isEmpty) return const SizedBox.shrink();

        final passCount = cat.questions
            .where((q) => q.answer == AnswerState.Pass)
            .length;
        final failCount = cat.questions
            .where((q) => q.answer == AnswerState.Fail)
            .length;
        final left = cat.totalCount - cat.answeredCount;

        final StatusBadge badge;
        if (cat.hasFailed) {
          badge = const StatusBadge.fail(dense: true);
        } else if (cat.allPassed) {
          badge = const StatusBadge.pass(dense: true);
        } else if (cat.answeredCount > 0) {
          badge = const StatusBadge.pending(label: 'In progress', dense: true);
        } else {
          badge = const StatusBadge.neutral(
            label: 'Not started',
            icon: Icons.radio_button_unchecked_rounded,
            dense: true,
          );
        }

        final radius = BorderRadius.circular(AppRadius.lg);
        final complete =
            cat.totalCount > 0 && cat.answeredCount >= cat.totalCount;
        final breakdown = [
          if (passCount > 0) '$passCount pass',
          if (failCount > 0) '$failCount fail',
          left > 0 ? '$left left' : 'All answered',
        ].join(' · ');

        return Container(
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            0,
            AppSpacing.page,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius,
            border: Border.all(
              color: cat.hasFailed ? fail.withValues(alpha: 0.35) : border,
            ),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Column(
              children: [
                // ── Header ──
                Material(
                  color: Colors.transparent,
                  child: Semantics(
                    button: true,
                    expanded: cat.isExpanded,
                    label: '${cat.title}. $breakdown',
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: () {
                        final origSec = provider.originalSectionIndex(
                          sectionIndex,
                        );
                        final origCat = provider.originalCategoryIndex(
                          sectionIndex,
                          categoryIndex,
                        );
                        provider.toggleCategory(origSec, origCat);
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 64),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            cat.title,
                                            style: AppText.sectionTitle,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        badge,
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: cat.progress,
                                        backgroundColor: surface2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              cat.hasFailed
                                                  ? fail
                                                  : complete
                                                  ? pass
                                                  : appColor,
                                            ),
                                        minHeight: 4,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs + 2),
                                    Text(
                                      '${cat.answeredCount}/${cat.totalCount} answered · $breakdown',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.caption,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              AnimatedRotation(
                                turns: cat.isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 250),
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Column(
                    children: [
                      const Divider(height: 1, thickness: 1, color: border),
                      for (final q in shown)
                        QuestionTile(
                          // Keyed so each tile keeps its own state (remark
                          // text) when the filter hides others.
                          key: ValueKey('q-$sectionIndex-$categoryIndex-$q'),
                          sectionIndex: sectionIndex,
                          categoryIndex: categoryIndex,
                          questionIndex: q,
                          accentColor: section.color,
                          isLast: q == shown.last,
                        ),
                    ],
                  ),
                  crossFadeState: cat.isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
