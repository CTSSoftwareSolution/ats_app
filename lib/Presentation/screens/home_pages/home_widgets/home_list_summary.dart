import 'package:flutter/material.dart';
import 'package:ats_app/utilities/new_app_theme/app_radius.dart';

import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/new_app_ui/app_count_pill.dart';
import '../../../../widgets/new_app_ui/app_skeleton.dart';

/// Summary line at the top of the appointment list:
/// "Appointments [134]" with the active category / search underneath.
class HomeListSummary extends StatelessWidget {
  /// Total matching appointments reported by the API (may be null).
  final num? totalRecords;

  /// Appointments currently loaded in the list.
  final int loadedCount;

  /// Selected category name ("All", "LMV", …).
  final String category;

  /// Current search text (empty when not searching).
  final String search;

  const HomeListSummary({
    super.key,
    required this.totalRecords,
    required this.loadedCount,
    required this.category,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    final total = (totalRecords != null && totalRecords! > 0)
        ? totalRecords!.toInt()
        : loadedCount;

    final scope = <String>[
      category.isEmpty || category == 'All' ? 'All categories' : category,
      if (search.isNotEmpty) '"$search"',
      if (loadedCount < total) 'Showing $loadedCount',
    ].join(' · ');

    return Semantics(
      container: true,
      label: '$total appointments. $scope',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Flexible(
                  child: Text(
                    'Appointments',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sectionTitle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppCountPill(count: total),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              scope,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption,
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading placeholder for [HomeListSummary] (title + count, scope line).
/// The list already sits inside the page gutter, so no horizontal padding.
class HomeListSummarySkeleton extends StatelessWidget {
  const HomeListSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 120, height: 18),
              SizedBox(width: AppSpacing.sm),
              SkeletonBox(width: 32, height: 18, radius: AppRadius.full),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          SkeletonBox(width: 150, height: 12),
        ],
      ),
    );
  }
}
