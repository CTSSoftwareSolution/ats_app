import 'package:flutter/material.dart';

import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Last item of a paged list: a small spinner while the next page loads, a
/// quiet "All N … shown" divider once everything is loaded, otherwise a gap.
class ListFooter extends StatelessWidget {
  final bool isLoadingMore;
  final bool reachedEnd;
  final int count;

  /// Item noun, singular and plural ("appointment" / "appointments").
  final String singular;
  final String plural;

  const ListFooter({
    super.key,
    required this.isLoadingMore,
    required this.reachedEnd,
    required this.count,
    required this.singular,
    required this.plural,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: Semantics(
            label: 'Loading more $plural',
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        ),
      );
    }
    if (!reachedEnd) return const SizedBox(height: AppSpacing.sm);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              count == 1 ? '1 $singular' : 'All $count $plural shown',
              style: AppText.caption,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
