
import 'package:flutter/widgets.dart';

/// Use Option 1 if you want to add more values later (font sizes, button height, spacing, etc.)

class ResponsiveConfig {
  final double screenW;
  final bool isTablet;
  final double contentMaxWidth;
  final double horizontalPadding;

  const ResponsiveConfig({
    required this.screenW,
    required this.isTablet,
    required this.contentMaxWidth,
    required this.horizontalPadding,
  });

  factory ResponsiveConfig.fromConstraints(BoxConstraints constraints) {
    final double screenW = constraints.maxWidth;
    final bool isTablet = screenW >= 600;
    return ResponsiveConfig(
      screenW: screenW,
      isTablet: isTablet,
      contentMaxWidth: isTablet ? 520 : double.infinity,
      horizontalPadding: isTablet ? 40 : 30,
    );
  }
}
