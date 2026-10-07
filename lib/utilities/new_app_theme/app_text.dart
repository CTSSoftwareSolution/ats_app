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
/// | label         | 14   | SemiBold | Row titles, banner / snackbar titles  |
/// | buttonCompact | 14   | SemiBold | Labels of 40dp inline card buttons    |
/// | body          | 14   | Medium   | Default body text, input text         |
/// | bodySecondary | 13   | Medium   | Supporting text, descriptions         |
/// | chip          | 13   | SemiBold | Chips, tabs, filter pills, meta rows  |
/// | fieldLabel    | 13   | SemiBold | Label above a form field              |
/// | tag           | 12   | SemiBold | Static metadata tags ([InfoChip])     |
/// | caption       | 12   | Medium   | Helper text, timestamps, counters     |
/// | navLabel      | 12   | SemiBold | Bottom navigation labels              |
/// | overline      | 11   | Bold     | UPPERCASE group labels                |
/// | appBarTitle   | 18   | SemiBold | App bar title (white, set by theme)   |
/// | dialogTitle   | 17   | Bold     | Dialog titles                         |
/// | input         | 15   | SemiBold | Text typed into a field               |
/// | badge         | 12   | Bold     | Status badges (11 when dense)         |
/// | plate         | 17   | Bold     | Registration number plate             |
///
/// Heading levels: H1 = [pageTitle], H2 = [sectionTitle], H3 = [title].
/// Nothing smaller than 11 is used for readable text.
///
/// Prefer a named style over `copyWith(fontSize: …)`; if a size is missing
/// from the scale, add it here rather than overriding it on a screen.
class AppText {
  /// Font features for numbers that update in place (counts, timers,
  /// progress) so the digits don't jitter: `style.copyWith(fontFeatures:
  /// AppText.tabular)`.
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  /// Large brand heading on dark backgrounds (splash / login hero).
  static const TextStyle display = TextStyle(
    fontFamily: "Black",
    fontSize: 24,
    color: textWhite,
    height: 1.15,
    letterSpacing: 0.5,
  );
  static const TextStyle pageTitle = TextStyle(
    fontFamily: "Bold",
    fontSize: 20,
    color: textPrimary,
    height: 1.25,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: "Bold",
    fontSize: 16,
    color: textPrimary,
    height: 1.3,
  );
  static const TextStyle title = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 15,
    color: textPrimary,
    height: 1.35,
  );
  /// Emphasised 14pt text: titles of compact rows (upload queue, analysis
  /// items), banner and snackbar titles.
  static const TextStyle label = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 14,
    color: textPrimary,
    height: 1.35,
  );
  static const TextStyle body = TextStyle(
    fontFamily: "Medium",
    fontSize: 14,
    color: textPrimary,
    height: 1.45,
  );
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: "Medium",
    fontSize: 13,
    color: textSecondary,
    height: 1.4,
  );

  /// Uses [na] rather than [textMuted] so small text keeps WCAG AA contrast
  /// (≈4.7:1) on white surfaces.
  static const TextStyle caption = TextStyle(
    fontFamily: "Medium",
    fontSize: 12,
    color: na,
    height: 1.35,
  );

  /// Small uppercase label above a group of content.
  static const TextStyle overline = TextStyle(
    fontFamily: "Bold",
    fontSize: 11,
    color: na,
    letterSpacing: 0.8,
  );

  /// Button labels. Colour comes from the button's foreground colour.
  static const TextStyle button = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 15,
    letterSpacing: 0.2,
  );

  /// Labels of compact (40dp) inline buttons on cards and rows ("Inspect",
  /// "Retest", "Retry"). Full-height buttons use [button].
  static const TextStyle buttonCompact = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 14,
    letterSpacing: 0.2,
  );

  /// Label shown above a form field.
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 13,
    color: textSecondary,
  );

  /// Compact label for chips, tabs and filter pills.
  static const TextStyle chip = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 13,
    color: textPrimary,
  );

  /// Static metadata tag text ([InfoChip], slot captions).
  static const TextStyle tag = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 12,
    color: textSecondary,
  );

  /// Label used in bottom navigation destinations.
  static const TextStyle navLabel = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 12,
    color: textSecondary,
  );

  /// Title placed on dark surfaces (media viewers, camera overlays).
  static const TextStyle titleOnDark = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 15,
    color: textWhite,
    height: 1.35,
  );

  /// App bar title. Applied by the theme; listed here so custom headers match.
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 18,
    color: textWhite,
    letterSpacing: 0.1,
  );

  /// Second line under an app bar title (vehicle number, context).
  static const TextStyle appBarSubtitle = TextStyle(
    fontFamily: "Medium",
    fontSize: 12,
    color: textWhiteSub,
    height: 1.35,
  );

  static const TextStyle dialogTitle = TextStyle(
    fontFamily: "Bold",
    fontSize: 17,
    color: textPrimary,
    height: 1.3,
  );

  /// Text the user types into a field.
  static const TextStyle input = TextStyle(
    fontFamily: "SemiBold",
    fontSize: 15,
    color: textPrimary,
  );

  /// Placeholder inside a field. Only gives an example; never the label.
  static const TextStyle hint = TextStyle(
    fontFamily: "Medium",
    fontSize: 15,
    color: textMuted,
  );

  /// Status badge label. Colour comes from the badge.
  static const TextStyle badge = TextStyle(
    fontFamily: "Bold",
    fontSize: 12,
    letterSpacing: 0.2,
  );

  static const TextStyle badgeDense = TextStyle(
    fontFamily: "Bold",
    fontSize: 11,
    letterSpacing: 0.2,
  );

  /// Registration number on [RegistrationPlate].
  static const TextStyle plate = TextStyle(
    fontFamily: "Bold",
    fontSize: 17,
    color: textPrimary,
    letterSpacing: 1.2,
  );
}
