import 'package:flutter/material.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';

/// One segment of the Yes / No answer selector (48px tall, fills its slot).
class AnswerButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback? onTap;

  /// Optional icon shown before the label.
  final IconData? icon;

  /// Fill used when selected; defaults to a light tint of [selectedColor].
  final Color? selectedBackground;

  const AnswerButton({super.key,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
    this.icon,
    this.selectedBackground,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    final fg = selected ? selectedColor : textSecondary;
    final bgColor = selected
        ? (selectedBackground ?? selectedColor.withValues(alpha: 0.1))
        : surface;

    return Material(
      color: bgColor,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? selectedColor : border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: selected ? selectedColor : textMuted),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 14,
                    fontFamily: selected ? "Bold" : "SemiBold",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
