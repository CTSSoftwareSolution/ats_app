import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';

/// One segment of the Yes / No answer selector (52dp, fills its slot).
///
/// The selected answer is a solid fill with white text so it reads at a
/// glance, even outdoors; unselected answers are outlined.
class AnswerButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback? onTap;

  /// Optional icon shown before the label.
  final IconData? icon;

  /// Kept for compatibility; the selected state is a solid [selectedColor].
  final Color? selectedBackground;

  const AnswerButton({
    super.key,
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
    final fg = selected ? textWhite : textPrimary;

    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? selectedColor : surface,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: AppSpacing.buttonHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: selected ? selectedColor : borderDark),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: AppIconSize.md,
                    color: selected ? textWhite : selectedColor,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.button.copyWith(
                      color: fg,
                      fontFamily: selected ? "Bold" : "SemiBold",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
