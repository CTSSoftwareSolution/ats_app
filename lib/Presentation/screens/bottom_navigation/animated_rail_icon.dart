import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';

class AnimatedRailIcon extends StatelessWidget {
  final String icon;
  final bool isActive;

  const AnimatedRailIcon({
    super.key,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha:0.0)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: Colors.white.withValues(alpha:0.9),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ]
              : [],
        ),
        padding: const EdgeInsets.all(6),
        child: ImageIcon(
          AssetImage(icon),
          size: 22,
          color: isActive
              ? whiteColor
              : bottomIconColor,
        ),
      ),
    );
  }
}
