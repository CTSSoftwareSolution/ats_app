
import 'package:flutter/material.dart';
import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../provider/inspection_form_provider.dart';

class SectionSummaryCard extends StatelessWidget {
  final SectionState section;
  const SectionSummaryCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final percent = (section.overallProgress * 100).toStringAsFixed(0);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: section.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(section.icon, color: section.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.label,
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 16,
                        fontFamily: "Bold",
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      section.subtitle,
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${section.totalAnswered}/${section.totalQuestions}',
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 18,
                      fontFamily: "Bold",
                    ),
                  ),
                  const Text(
                    'Completed',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: section.overallProgress,
              backgroundColor: surface2,
              valueColor: AlwaysStoppedAnimation<Color>(section.color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${section.categories.length} categories',
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '$percent% done',
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 12,
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
