import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';

/// Flat white group with hairline dividers between its tiles.
class ProfileMenuSection extends StatelessWidget {
  final List<Widget> children;

  const ProfileMenuSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: radius,
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  const Divider(indent: 68, height: 1),
              ],
            ],
          ),
        ),
      ),
    );
  }
}