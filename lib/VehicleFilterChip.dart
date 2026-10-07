import 'package:ats_app/widgets/new_app_ui/app_filter_chip.dart';
import 'package:flutter/material.dart';

/// Kept for existing call sites; it is the standard [AppFilterChip].
class VehicleFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppFilterChip(label: label, selected: isSelected, onTap: onTap);
  }
}
