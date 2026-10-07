import 'package:flutter/material.dart';
import '../../../utilities/color_data.dart';
import '../../../widgets/new_app_ui/app_navigation.dart';

/// Rail destination icon: the shared [AppNavIndicator] in white on the
/// brand rail (a 16% white pill when active, muted icon otherwise).
class AnimatedRailIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const AnimatedRailIcon({
    super.key,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AppNavIndicator(
      icon: icon,
      selected: isActive,
      selectedColor: textWhite,
      unselectedColor: textWhiteSub,
      pillColor: textWhite.withValues(alpha: 0.16),
    );
  }
}
