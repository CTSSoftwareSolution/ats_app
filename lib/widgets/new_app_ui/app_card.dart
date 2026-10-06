import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';

/// Flat white card: hairline border, no shadow. The standard container for
/// list items and grouped content. Pass [onTap] to make the whole card
/// tappable; use [borderColor] to signal state (e.g. pass / fail).
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.onTap,
    this.borderColor,
    this.color = surface,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor ?? border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
