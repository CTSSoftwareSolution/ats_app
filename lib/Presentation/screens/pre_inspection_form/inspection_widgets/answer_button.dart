import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';

class AnswerButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback? onTap;
  final IconData? icon;

  const AnswerButton({super.key,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? whiteColor : textSecondary;
    return Material(
      color: selected ? selectedColor : surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: selected ? selectedColor : borderDark),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40, minWidth: 84),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 14,
                    fontFamily: selected ? "Bold" : "SemiBold",
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
