import 'package:ats_app/widgets/new_app_ui/app_state_view.dart';
import 'package:flutter/material.dart';

/// Scrollable, centred [AppStateView.empty]. Kept for existing call sites;
/// new code can use [AppStateView.empty] directly.
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
        child: AppStateView.empty(
          icon: icon,
          title: title,
          message: subtitle,
          actionLabel: actionLabel ?? 'Refresh',
          onAction: hasAction ? onAction : null,
        ),
      ),
    );
  }
}
