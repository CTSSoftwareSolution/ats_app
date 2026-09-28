import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

Widget navigationIcon(
  String icon,
  int index,
  String title,
  int currentIndex,
  ValueChanged<int> onTabSelected,
) {
  final bool isActive = currentIndex == index;
  final Color color = isActive ? whiteColor : textWhiteSub;

  return Expanded(
    child: Semantics(
      selected: isActive,
      button: true,
      label: title,
      child: InkWell(
        onTap: () => onTabSelected.call(index),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ImageIcon(
                  AssetImage(icon),
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11.5,
                  fontFamily: isActive ? "Bold" : "Medium",
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
