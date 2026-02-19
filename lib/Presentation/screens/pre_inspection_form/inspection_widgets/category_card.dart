
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/question_tile.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/status_chip.dart';
import 'package:flutter/material.dart';
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
        final section = provider.filteredSections[sectionIndex];
        final cat = section.categories[categoryIndex];

        Color statusColor;
        String statusLabel;

        if (cat.hasFailed) {
          statusColor = Colors.red;
          statusLabel = 'Fail';
        } else if (cat.allPassed) {
          statusColor = Colors.green;
          statusLabel = 'Pass';
        } else if (cat.answeredCount > 0) {
          statusColor = Colors.orange;
          statusLabel = 'Partial';
        } else {
          statusColor = Colors.grey.shade400;
          statusLabel = 'Pending';
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
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
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
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
                                      backgroundColor: Colors.grey.shade200,
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
                                    color: Colors.grey.shade500,
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
                            color: Colors.grey.shade500),
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
                        color: Colors.grey.shade100,
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