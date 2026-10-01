import 'package:flutter/material.dart';

import '../utilities/app_theme.dart';
import '../utilities/color_data.dart';
import '../utilities/image_data.dart';

/// Small reusable building blocks shared by the inspection screens.

/// Colored pill for Pass / Fail / Pending / Captured / Required style states.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;
  final bool dense;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.icon,
    this.dense = false,
  });

  const StatusBadge.pass({super.key, this.label = 'Pass', this.dense = false})
      : color = pass,
        background = passLight,
        icon = Icons.check_circle_rounded;

  const StatusBadge.fail({super.key, this.label = 'Fail', this.dense = false})
      : color = fail,
        background = failLight,
        icon = Icons.cancel_rounded;

  const StatusBadge.pending({super.key, this.label = 'Pending', this.dense = false})
      : color = warn,
        background = warnLight,
        icon = Icons.schedule_rounded;

  const StatusBadge.neutral({super.key, required this.label, this.icon, this.dense = false})
      : color = na,
        background = naLight;

  /// Maps a Pass/Fail string coming from the API to the matching badge.
  factory StatusBadge.fromResult(String? result, {bool dense = false}) {
    final value = (result ?? '').trim().toLowerCase();
    if (value == 'pass') return StatusBadge.pass(label: result!.trim(), dense: dense);
    if (value == 'fail') return StatusBadge.fail(label: result!.trim(), dense: dense);
    return StatusBadge.pending(
      label: value.isEmpty ? 'Pending' : result!.trim(),
      dense: dense,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dense ? 12 : 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: dense ? 11 : 12,
              fontFamily: "Bold",
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Neutral icon + text pill for secondary metadata (class, make, fuel, …).
class InfoChip extends StatelessWidget {
  final IconData? icon;
  final String label;

  const InfoChip({super.key, this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: surface2,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textSecondary),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: "SemiBold",
                color: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Registration number styled like a number plate so it is scannable at a glance.
class RegistrationPlate extends StatelessWidget {
  final String number;
  final double fontSize;

  const RegistrationPlate({super.key, required this.number, this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textPrimary, width: 1.4),
      ),
      child: Text(
        number.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: "Bold",
          fontSize: fontSize,
          color: textPrimary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// White card with a hairline border and very soft shadow.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderColor,
    this.color = surface,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        border: Border.all(color: borderColor ?? border),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Full-width primary action button with a consistent 52px height.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: color ?? appColor,
      minimumSize: const Size.fromHeight(52),
    );
    return icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: 20),
            label: Text(label),
          );
  }
}

/// Floating container at the bottom of a screen that holds its primary action.
/// It takes its own space (placed after the scrolling content or in
/// `Scaffold.bottomNavigationBar`), so it never covers content, and it stays
/// clear of the system navigation area.
class BottomActionBar extends StatelessWidget {
  final Widget child;

  const BottomActionBar({super.key, required this.child});

  /// Inner padding; outer radius minus this equals the button radius (12),
  /// so the button corners sit concentric with the container's.
  static const double _inset = 8;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md + _inset);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.only(bottom: _inset, left: _inset, right: _inset),
        // decoration: BoxDecoration(
        //   color: surface,
        //   borderRadius: radius,
        //   border: Border.all(color: border.withValues(alpha: 0.6)),
          // boxShadow: [
          //   BoxShadow(
          //     color: navy.withValues(alpha: 0.10),
          //     blurRadius: 24,
          //     offset: const Offset(0, 8),
          //   ),
          //   BoxShadow(
          //     color: navy.withValues(alpha: 0.04),
          //     blurRadius: 4,
          //     offset: const Offset(0, 1),
          //   ),
          // ],
       // ),
        child: child,
      ),
    );
  }
}

/// "x of y captured" header with a progress bar, used by the capture screens.
class CaptureProgressHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int done;
  final int total;
  final String? trailingLabel;

  const CaptureProgressHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.total,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final complete = total > 0 && done >= total;
    final progress = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
    return Container(
      color: surface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Bold",
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12.5, color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              complete
                  ? StatusBadge.pass(label: trailingLabel ?? '$done/$total')
                  : StatusBadge(
                      label: trailingLabel ?? '$done/$total',
                      color: appColor,
                      background: accentLight,
                    ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: surface2,
              valueColor: AlwaysStoppedAnimation<Color>(complete ? pass : appColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Standard back button used by the pushed screens.
class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: onPressed,
      icon: const ImageIcon(AssetImage(backArrowIcon), color: whiteColor, size: 20),
    );
  }
}

/// Icon + single line of secondary text (appointment date, booking id, …).
class MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const MetaRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: "SemiBold",
              color: textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Standard dialog body: icon, title, message and a row of actions.
/// Shown with `showDialog(builder: (_) => AppDialog(...))`.
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
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
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Bold",
                        fontSize: 17,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  if (onClose != null)
                    IconButton(
                      tooltip: 'Close',
                      onPressed: onClose,
                      icon: const Icon(Icons.close_rounded, size: 20, color: textMuted),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                style: const TextStyle(fontSize: 14.5, color: textSecondary, height: 1.5),
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

/// Standard modal bottom sheet shell: drag handle, optional title/subtitle,
/// content, and safe-area aware bottom padding (keyboard aware as well).
/// Use with `showModalBottomSheet(backgroundColor: Colors.transparent, ...)`.
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;

  const AppBottomSheet({super.key, this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
        decoration: const BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20 + media.padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (title != null) Text(title!, style: AppText.sectionTitle),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: AppText.bodySecondary),
              ],
              if (title != null || subtitle != null) const SizedBox(height: AppSpacing.lg),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Centered empty / error / pending state with an optional retry action.
class AppStateView extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? message;
  final String actionLabel;
  final VoidCallback? onAction;

  const AppStateView({
    super.key,
    required this.icon,
    this.color = textMuted,
    required this.title,
    this.message,
    this.actionLabel = 'Retry',
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, textAlign: TextAlign.center, style: AppText.sectionTitle),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(message!, textAlign: TextAlign.center, style: AppText.bodySecondary),
          ],
          if (onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }
}
