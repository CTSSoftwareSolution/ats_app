import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import 'custom_text.dart';

Widget navigationIcon(
  String icon,
  int index,
  String title,
  int currentIndex,
  ValueChanged<int> onTabSelected,
) {
  final bool isActive = currentIndex == index;

  return Expanded(
    child: InkWell(
      onTap: () => onTabSelected.call(index),
      child: AnimatedScale(
        scale: isActive ? 1.0 : 0.9,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.0)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.9),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: ImageIcon(
                  AssetImage(icon),
                  size: 20,
                  color: isActive ? whiteColor : bottomIconColor,
                ),
              ),
              3.height,
              CustomText(
                text: title,
                fontSize: 12,
                fontFamily: "Bold",
                textColor: isActive ? whiteColor : bottomIconColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
