import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import 'app_icon_tile.dart';
import 'app_spinner.dart';

/// Centred icon + title + message (+ optional action) used for every
/// full-area empty, error and success state. For a message inside a page
/// (above a list, inside a sheet) use [AppBanner] instead.
///
/// * [AppStateView.empty] – neutral tint; the action is optional
///   (e.g. "Refresh").
/// * [AppStateView.error] – red tint; always offers a retry.
/// * [AppStateView.success] – green tint; the action is the next step.
class AppStateView extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? message;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;

  const AppStateView({
    super.key,
    required this.icon,
    this.color = na,
    required this.title,
    this.message,
    this.actionLabel = 'Retry',
    this.actionIcon = Icons.refresh_rounded,
    this.onAction,
  });

  /// Nothing to show yet (no data, no search results, filter matches nothing).
  const AppStateView.empty({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.message,
    this.actionLabel = 'Refresh',
    this.actionIcon = Icons.refresh_rounded,
    this.onAction,
  }) : color = na;

  /// Something failed to load. [onAction] should repeat the same request.
  const AppStateView.error({
    super.key,
    this.icon = Icons.cloud_off_rounded,
    this.title = "Something went wrong",
    this.message = "Check your connection and try again.",
    this.actionLabel = 'Retry',
    this.actionIcon = Icons.refresh_rounded,
    required this.onAction,
  }) : color = fail;

  /// A task finished (submitted, uploaded, saved). [onAction] is the next
  /// step, e.g. "Done" or "Back to home".
  const AppStateView.success({
    super.key,
    this.icon = Icons.check_circle_outline_rounded,
    required this.title,
    this.message,
    this.actionLabel = 'Done',
    this.actionIcon = Icons.arrow_forward_rounded,
    this.onAction,
  }) : color = pass;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconTile.large(icon: icon, color: color),
          const SizedBox(height: AppSpacing.lg),
          Text(title, textAlign: TextAlign.center, style: AppText.sectionTitle),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: AppText.bodySecondary,
              ),
            ),
          ],
          if (onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon, size: AppIconSize.md),
              label: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-area loading state: brand-colour spinner with an optional message.
/// Use for a screen or panel whose content is loading for the first time
/// (lists use shimmer placeholders instead; blocking actions use the global
/// CustomLoader overlay).
class AppLoadingView extends StatelessWidget {
  final String? message;

  const AppLoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: message ?? 'Loading',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppSpinner.large(),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppText.bodySecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
