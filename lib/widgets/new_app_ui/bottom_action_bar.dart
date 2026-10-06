import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_spacing.dart';

/// Docked bar at the bottom of a screen that holds its primary action.
/// It takes its own space (placed after the scrolling content or in
/// `Scaffold.bottomNavigationBar`), so it never covers content, lines up with
/// the page gutter and stays clear of the system navigation area.
class BottomActionBar extends StatelessWidget {
  final Widget child;

  const BottomActionBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.md,
          ),
          child: child,
        ),
      ),
    );
  }
}
