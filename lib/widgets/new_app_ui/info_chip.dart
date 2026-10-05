import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_radius.dart';

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