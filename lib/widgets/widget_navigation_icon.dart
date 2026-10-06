import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

import '../utilities/new_app_theme/app_radius.dart';
import '../utilities/new_app_theme/app_text.dart';

/// One destination of the docked bottom navigation bar: icon inside a tinted
/// pill when active, with a label underneath.
Widget navigationIcon(
  String icon,
  int index,
  String title,
  int currentIndex,
  ValueChanged<int> onTabSelected,
) {
  final bool isActive = currentIndex == index;
  final Color color = isActive ? appColor : textSecondary;

  return Expanded(
    child: Semantics(
      selected: isActive,
      button: true,
      label: title,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => onTabSelected.call(index),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive ? accentLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ImageIcon(AssetImage(icon), size: 20, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.navLabel.copyWith(
                  fontFamily: isActive ? "Bold" : "SemiBold",
                  color: isActive ? appColor : textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
