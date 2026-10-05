

import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/new_app_theme/app_radius.dart';
import 'package:flutter/material.dart';


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
    final radius = BorderRadius.circular(AppRadius.md);
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? appColor : surface,
        animationDuration: const Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: isSelected ? appColor : border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "SemiBold",
                    fontSize: 13,
                    color: isSelected ? Colors.white : textPrimary,
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
