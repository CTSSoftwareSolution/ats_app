import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';

/// Icon on a 10% tint of its own colour. The only decorative icon treatment
/// in the app; it gives dialogs, states and menu rows a consistent anchor.
///
/// * [AppIconTile] – 40dp rounded square: dialogs, list / menu rows
/// * [AppIconTile.large] – 64dp circle: full-area empty / error / success
class AppIconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final bool circle;

  const AppIconTile({super.key, required this.icon, this.color = appColor})
    : size = 40,
      iconSize = AppIconSize.md + 2,
      circle = false;

  const AppIconTile.large({
    super.key,
    required this.icon,
    this.color = appColor,
  }) : size = 64,
       iconSize = AppIconSize.xl - 2,
       circle = true;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
