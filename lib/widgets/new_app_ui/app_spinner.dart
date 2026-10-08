import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';

/// The app's one spinner. Brand-coloured by default; pass [color] for use on
/// dark or brand surfaces (e.g. [textWhite]).
///
/// * [AppSpinner.large] (32dp) – a whole screen or panel is loading
/// * [AppSpinner] (24dp)       – inline: list footer, inside a slot
/// * [AppSpinner.small] (20dp) – inside a button or badge
class AppSpinner extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  /// 0–1 for determinate progress (e.g. image download); null spins.
  final double? value;

  /// Read by screen readers; null when a surrounding widget already says
  /// what is loading.
  final String? semanticsLabel;

  const AppSpinner({
    super.key,
    this.color = appColor,
    this.value,
    this.semanticsLabel,
  }) : size = 24,
       strokeWidth = 2.5;

  const AppSpinner.large({
    super.key,
    this.color = appColor,
    this.value,
    this.semanticsLabel,
  }) : size = AppIconSize.xl,
       strokeWidth = 3;

  const AppSpinner.small({
    super.key,
    this.color = appColor,
    this.value,
    this.semanticsLabel,
  }) : size = AppIconSize.md,
       strokeWidth = 2.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        value: value,
        color: color,
        strokeWidth: strokeWidth,
        backgroundColor: Colors.transparent,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}
