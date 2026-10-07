import 'package:flutter/material.dart';

import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_spacing.dart';

/// Outlined companion to [PrimaryButton] with the same 52dp height, for the
/// second action in a pair (Cancel, Reset, Back…). Pass [color] = `fail`
/// for a destructive secondary action ("Remove photo").
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
      foregroundColor: color,
      side: color == null ? null : BorderSide(color: color!),
    );
    return icon == null
        ? OutlinedButton(onPressed: onPressed, style: style, child: Text(label))
        : OutlinedButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: AppIconSize.md),
            label: Text(label),
          );
  }
}
