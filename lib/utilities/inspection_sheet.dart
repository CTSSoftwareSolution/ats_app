import 'package:flutter/material.dart';
import '../widgets/new_app_ui/app_bottom_sheet.dart';
import 'inspection_tile.dart';
import 'new_app_theme/app_spacing.dart';

class InspectionSheet extends StatelessWidget {
  final Function(String) onSelect;
  const InspectionSheet({super.key, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Select Inspection Type',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InspectionTile(
            icon: Icons.person_outline_rounded,
            label: 'Visual Inspection',
            description: 'Performed by a technician',
            onTap: () {
              Navigator.pop(context);
              onSelect('Visual Inspection');
            },
          ),
          const SizedBox(height: AppSpacing.md),
          InspectionTile(
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