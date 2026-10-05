import 'package:flutter/material.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';

class BottomActionBar extends StatelessWidget {
  final Widget child;

  const BottomActionBar({super.key, required this.child});

  static const double _inset = 8;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md + _inset);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.only(bottom: _inset, left: _inset, right: _inset),
        child: child,
      ),
    );
  }
}