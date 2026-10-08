import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_radius.dart';

/// Thin rounded linear progress bar on a neutral track.
///
/// * [value] null shows indeterminate progress (upload in flight).
/// * [AppProgressBar] is 4dp (inside cards, rows and slots);
///   [AppProgressBar.thick] is 6dp (page / section headers).
/// * Turns [pass] green once [value] reaches 1, unless [color] is given.
class AppProgressBar extends StatelessWidget {
  final double? value;
  final Color? color;
  final double height;

  const AppProgressBar({super.key, this.value, this.color}) : height = 4;

  const AppProgressBar.thick({super.key, this.value, this.color})
    : height = 6;

  @override
  Widget build(BuildContext context) {
    final complete = value != null && value! >= 1;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: LinearProgressIndicator(
        value: value?.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: surface2,
        color: color ?? (complete ? pass : appColor),
      ),
    );
  }
}
