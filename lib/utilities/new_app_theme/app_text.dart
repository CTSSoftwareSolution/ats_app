import 'package:flutter/material.dart';

import '../color_data.dart';

/// ATS type scale (Gilroy).
///
/// Gilroy is bundled as one family per weight, so weight is chosen with
/// `fontFamily`, never `fontWeight`:
///   "Medium"   – regular text (≈500)
///   "SemiBold" – titles, labels, buttons (≈600)
///   "Bold"     – headings, badges (≈700)
///   "Black"    – brand display only
///
/// | Style         | Size | Family   | Use                                   |
/// |---------------|------|----------|---------------------------------------|
/// | display       | 24   | Black    | Brand heading on dark (splash/login)  |
/// | pageTitle     | 20   | Bold     | Screen heading inside content         |
/// | sectionTitle  | 16   | Bold     | Card / section / sheet headings       |
/// | title         | 15   | SemiBold | List item titles, question text       |
/// | button        | 15   | SemiBold | Button labels                         |
/// | body          | 14   | Medium   | Default body text, input text         |
/// | bodySecondary | 13   | Medium   | Supporting text, descriptions         |
/// | chip          | 13   | SemiBold | Chips, tabs, filter pills, meta rows  |
/// | fieldLabel    | 13   | SemiBold | Label above a form field              |
/// | caption       | 12   | Medium   | Helper text, timestamps, counters     |
/// | navLabel      | 12   | SemiBold | Bottom navigation labels              |
/// | overline      | 11   | Bold     | UPPERCASE group labels                |
///
/// Nothing smaller than 11 is used for readable text.
class AppText {
  /// Large brand heading on dark backgrounds (splash / login hero).
  static const TextStyle display = TextStyle(
    fontFamily: "Black",
    fontSize: 24,
    color: textWhite,
    height: 1.15,
    letterSpacing: 0.5,
  );
  static const TextStyle pageTitle =
  TextStyle(fontFamily: "Bold", fontSize: 20, color: textPrimary, height: 1.25);
  static const TextStyle sectionTitle =
  TextStyle(fontFamily: "Bold", fontSize: 16, color: textPrimary, height: 1.3);
  static const TextStyle title =
  TextStyle(fontFamily: "SemiBold", fontSize: 15, color: textPrimary, height: 1.35);
  static const TextStyle body =
  TextStyle(fontFamily: "Medium", fontSize: 14, color: textPrimary, height: 1.45);
  static const TextStyle bodySecondary =
  TextStyle(fontFamily: "Medium", fontSize: 13, color: textSecondary, height: 1.4);

  /// Uses [na] rather than [textMuted] so small text keeps WCAG AA contrast
  /// (≈4.7:1) on white surfaces.
  static const TextStyle caption =
  TextStyle(fontFamily: "Medium", fontSize: 12, color: na, height: 1.35);

  /// Small uppercase label above a group of content.
  static const TextStyle overline = TextStyle(
    fontFamily: "Bold",
    fontSize: 11,
    color: na,
    letterSpacing: 0.8,
  );

  /// Button labels. Colour comes from the button's foreground colour.
  static const TextStyle button =
  TextStyle(fontFamily: "SemiBold", fontSize: 15, letterSpacing: 0.2);

  /// Label shown above a form field.
  static const TextStyle fieldLabel =
  TextStyle(fontFamily: "SemiBold", fontSize: 13, color: textSecondary);

  /// Compact label for chips, tabs and filter pills.
  static const TextStyle chip =
  TextStyle(fontFamily: "SemiBold", fontSize: 13, color: textPrimary);

  /// Label used in bottom navigation destinations.
  static const TextStyle navLabel =
  TextStyle(fontFamily: "SemiBold", fontSize: 12, color: textSecondary);

  /// Title placed on dark surfaces (media viewers, camera overlays).
  static const TextStyle titleOnDark =
  TextStyle(fontFamily: "SemiBold", fontSize: 15, color: textWhite, height: 1.35);
}
