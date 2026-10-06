import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';

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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: accentLight,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '$total',
                    maxLines: 1,
                    style: AppText.chip.copyWith(color: appColor, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
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
