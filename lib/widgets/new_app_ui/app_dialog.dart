import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Standard confirmation / alert dialog: tinted icon tile, title, message and
/// a row of equal-width actions (secondary first, primary last).
///
/// Use [iconColor] = [fail] for destructive confirmations and [warn] for
/// warnings; the default is the brand colour.
class AppDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final List<Widget> actions;
  final VoidCallback? onClose;

  const AppDialog({
    super.key,
    this.icon = Icons.info_outline_rounded,
    this.iconColor = appColor,
    required this.title,
    required this.message,
    required this.actions,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl - 4, AppSpacing.xl - 4, AppSpacing.xl - 4, AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(icon, color: iconColor, size: AppIconSize.md + 2),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      title,
                      style: AppText.sectionTitle.copyWith(fontSize: 17),
                    ),
                  ),
                  if (onClose != null)
                    IconButton(
                      tooltip: 'Close',
                      onPressed: onClose,
                      icon: const Icon(Icons.close_rounded, size: AppIconSize.md, color: na),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                style: AppText.body.copyWith(color: textSecondary, height: 1.5),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(child: actions[i]),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
