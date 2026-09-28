
import 'package:flutter/material.dart';

import 'utilities/color_data.dart';

/// A simple, reusable empty state widget.
///
/// Usage:
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.search_off_rounded,
///   title: 'No Results Found',
///   subtitle: 'Try changing the filter or search term',
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.inbox_rounded,
    this.title = 'Nothing here yet',
    this.subtitle = 'Try adjusting your search or filters',
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: accentLight,
              ),
              child: Icon(icon, size: 34, color: appColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontFamily: "Bold",
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
                height: 1.45,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
