import 'package:flutter/material.dart';

import 'utilities/color_data.dart';
import 'widgets/app_ui.dart';

/// Empty / no-results state used by the Home and Result lists.
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
    final hasAction = actionLabel != null && onAction != null;
    return Center(
      child: SingleChildScrollView(
        child: AppStateView(
          icon: icon,
          color: appColor,
          title: title,
          message: subtitle,
          actionLabel: actionLabel ?? 'Retry',
          onAction: hasAction ? onAction : null,
        ),
      ),
    );
  }
}
