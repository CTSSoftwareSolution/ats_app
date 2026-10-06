import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/question_tile.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../provider/inspection_form_provider.dart';

class CategoryCard extends StatelessWidget {
  final int sectionIndex;
  final int categoryIndex;


  const CategoryCard({super.key,
    required this.sectionIndex,
    required this.categoryIndex,

  });

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {

        // final section = provider.sections[sectionIndex];
        // final cat = section.categories[categoryIndex];
      //  final section = provider.filteredSections[sectionIndex];
        final section = provider.visibleSections[sectionIndex];
        final cat = section.categories[categoryIndex];

        Color statusColor;
        Color statusBackground;
        String statusLabel;

        if (cat.hasFailed) {
          statusColor = fail;
          statusBackground = failLight;
          statusLabel = 'Fail';
        } else if (cat.allPassed) {
          statusColor = pass;
          statusBackground = passLight;
          statusLabel = 'Pass';
        } else if (cat.answeredCount > 0) {
          statusColor = warn;
          statusBackground = warnLight;
          statusLabel = 'Partial';
        } else {
          statusColor = na;
          statusBackground = naLight;
          statusLabel = 'Pending';
        }

        final radius = BorderRadius.circular(AppRadius.lg);
        final complete = cat.totalCount > 0 && cat.answeredCount >= cat.totalCount;

        return Container(
          margin: const EdgeInsets.fromLTRB(
              AppSpacing.page, 0, AppSpacing.page, AppSpacing.md),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius,
            border: Border.all(color: border),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Column(
              children: [
                // ── Header ──
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final origSec = provider.originalSectionIndex(sectionIndex);
                      final origCat = provider.originalCategoryIndex(sectionIndex, categoryIndex);
                      provider.toggleCategory(origSec, origCat);
                    },
                    // onTap: () =>
                    //     provider.toggleCategory(sectionIndex, categoryIndex),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 64),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg, AppSpacing.md, AppSpacing.md, AppSpacing.md),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cat.title,
                                          style: AppText.title,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: StatusChip(
                                          label: statusLabel,
                                          color: statusColor,
                                          background: statusBackground,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: cat.progress,
                                            backgroundColor: surface2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                complete ? pass : appColor),
                                            minHeight: 4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text(
                                        '${cat.answeredCount}/${cat.totalCount}',
                                        style: AppText.caption.copyWith(
                                          color: textSecondary,
                                          fontFamily: "SemiBold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AnimatedRotation(
                              turns: cat.isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: textSecondary),
                            ),
                          ],
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
                      ...cat.questions.asMap().entries.map((entry) {
                        return QuestionTile(
                          sectionIndex: sectionIndex,
                          categoryIndex: categoryIndex,
                          questionIndex: entry.key,
                          accentColor: section.color,
                          isLast: entry.key == cat.questions.length - 1,

                        );
                      }),
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
