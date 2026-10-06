import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  /// Shows a spinner in place of the label and ignores taps while true.
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: color ?? appColor,
      minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
    );
    final VoidCallback? handler = loading ? null : onPressed;
    if (loading) {
      return FilledButton(
        onPressed: handler,
        style: style,
        child: Semantics(
          label: label,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: textMuted,
            ),
          ),
        ),
      );
    }
    return icon == null
        ? FilledButton(onPressed: handler, style: style, child: Text(label))
        : FilledButton.icon(
            onPressed: handler,
            style: style,
            icon: Icon(icon, size: AppIconSize.md),
            label: Text(label),
          );
  }
}
