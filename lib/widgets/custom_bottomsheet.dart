import 'package:flutter/material.dart';

import '../utilities/app_theme.dart';
import '../utilities/color_data.dart';
import 'app_ui.dart';

void showInspectionSheet(BuildContext context, {required Function(String) onSelect}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _InspectionSheet(onSelect: onSelect),
  );
}

class _InspectionSheet extends StatelessWidget {
  final Function(String) onSelect;
  const _InspectionSheet({required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Select Inspection Type',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InspectionTile(
            icon: Icons.person_outline_rounded,
            label: 'Visual Inspection',
            description: 'Performed by a technician',
            onTap: () {
              Navigator.pop(context);
              onSelect('Visual Inspection');
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _InspectionTile(
            icon: Icons.precision_manufacturing_outlined,
            label: 'Under PIT Inspection',
            description: '',
            onTap: () {
              Navigator.pop(context);
              onSelect('Under-PIT Inspection');
            },
          ),
        ],
      ),
    );
  }
}

class _InspectionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _InspectionTile({
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
