import 'package:flutter/material.dart';
import '../widgets/new_app_ui/app_card.dart';
import 'color_data.dart';
import 'new_app_theme/app_radius.dart';
import 'new_app_theme/app_spacing.dart';
import 'new_app_theme/app_text.dart';

class InspectionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const InspectionTile({super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: appColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.title),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(description, style: AppText.caption),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: textMuted, size: 22),
        ],
      ),
    );
  }
}