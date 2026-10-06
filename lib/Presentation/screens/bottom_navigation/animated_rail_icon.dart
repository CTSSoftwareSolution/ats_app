import 'package:flutter/material.dart';
import '../../../utilities/color_data.dart';

/// Rail destination icon: white inside a soft pill when active, muted otherwise.
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.16)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ImageIcon(
        AssetImage(icon),
        size: 22,
        color: isActive ? whiteColor : textWhiteSub,
      ),
    );
  }
}
