import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

enum AppBannerTone { info, success, warning, error }

/// Inline message that sits inside a page or sheet, above the content it
/// is about ("2 uploads failed", "Location is off", "All parts captured").
/// Tinted background, coloured left icon, optional title and one action.
///
/// For a whole-screen state use [AppStateView]; for a passing confirmation
/// use a toast (`CustomLoader.message`).
class AppBanner extends StatelessWidget {
  final AppBannerTone tone;
  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const AppBanner({
    super.key,
    required this.tone,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  const AppBanner.info({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  }) : tone = AppBannerTone.info;

  const AppBanner.success({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  }) : tone = AppBannerTone.success;

  const AppBanner.warning({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  }) : tone = AppBannerTone.warning;

  const AppBanner.error({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  }) : tone = AppBannerTone.error;

  (Color, Color, IconData) get _style => switch (tone) {
    AppBannerTone.info => (infoColor, infoLight, Icons.info_outline_rounded),
    AppBannerTone.success => (
      pass,
      passLight,
      Icons.check_circle_outline_rounded,
    ),
    AppBannerTone.warning => (warn, warnLight, Icons.warning_amber_rounded),
    AppBannerTone.error => (fail, failLight, Icons.error_outline_rounded),
  };

  @override
  Widget build(BuildContext context) {
    final (color, background, defaultIcon) = _style;
    final hasAction = actionLabel != null && onAction != null;
    return Semantics(
      container: true,
      liveRegion: tone == AppBannerTone.error,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          hasAction ? AppSpacing.xs : AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? defaultIcon, color: color, size: AppIconSize.md),
            const SizedBox(width: AppSpacing.md),
            // The action sits under the message so the text keeps the full
            // width on narrow phones and with large text.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(title!, style: AppText.label),
                    const SizedBox(height: AppSpacing.xxs),
                  ],
                  Text(
                    message,
                    style: AppText.bodySecondary.copyWith(color: textPrimary),
                  ),
                  if (hasAction)
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        foregroundColor: color,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, AppSpacing.compactHeight),
                      ),
                      child: Text(actionLabel!),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
