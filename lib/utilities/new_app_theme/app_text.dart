import 'package:flutter/material.dart';

import '../color_data.dart';

class AppText {
  static const TextStyle pageTitle =
  TextStyle(fontFamily: "Bold", fontSize: 20, color: textPrimary, height: 1.25);
  static const TextStyle sectionTitle =
  TextStyle(fontFamily: "Bold", fontSize: 16, color: textPrimary, height: 1.3);
  static const TextStyle title =
  TextStyle(fontFamily: "SemiBold", fontSize: 15, color: textPrimary, height: 1.35);
  static const TextStyle body =
  TextStyle(fontFamily: "Medium", fontSize: 14, color: textPrimary, height: 1.45);
  static const TextStyle bodySecondary =
  TextStyle(fontFamily: "Medium", fontSize: 13.5, color: textSecondary, height: 1.4);
  static const TextStyle caption =
  TextStyle(fontFamily: "Medium", fontSize: 12, color: textMuted, height: 1.35);

  /// Small uppercase label above a group of content.
  static const TextStyle overline = TextStyle(
    fontFamily: "Bold",
    fontSize: 11,
    color: textMuted,
    letterSpacing: 0.8,
  );
}