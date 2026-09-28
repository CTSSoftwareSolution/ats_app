
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/question_tile.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/status_chip.dart';
import 'package:flutter/material.dart';
import '../../../../utilities/color_data.dart';
import 'package:provider/provider.dart';

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
        String statusLabel;

        if (cat.hasFailed) {
          statusColor = fail;
          statusLabel = 'Fail';
        } else if (cat.allPassed) {
          statusColor = pass;
          statusLabel = 'Pass';
        } else if (cat.answeredCount > 0) {
          statusColor = warn;
          statusLabel = 'Partial';
        } else {
          statusColor = na;
          statusLabel = 'Pending';
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: cat.hasFailed ? fail.withValues(alpha: 0.35) : border,
            ),
          ),
          child: Column(
            children: [
              // ── Header ──
              InkWell(
                onTap: () {
                  final origSec = provider.originalSectionIndex(sectionIndex);
                  final origCat = provider.originalCategoryIndex(sectionIndex, categoryIndex);
                  provider.toggleCategory(origSec, origCat);
                },
                // onTap: () =>
                //     provider.toggleCategory(sectionIndex, categoryIndex),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.title,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontFamily: "Bold",
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: cat.progress,
                                      backgroundColor: surface2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          section.color),
                                      minHeight: 4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${cat.answeredCount}/${cat.totalCount}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusChip(label: statusLabel, color: statusColor),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: cat.isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(Icons.keyboard_arrow_down_rounded,
                            color: textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    Divider(
                        height: 1,
                        color: border,
                        indent: 16,
                        endIndent: 16),
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
        );
      },
    );
  }
}