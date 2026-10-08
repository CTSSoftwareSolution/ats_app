/// Breakpoints and content widths for phone / tablet layouts.
///
/// Width classes follow Material 3:
///   compact  < 600   phones                   bottom navigation, 1 column
///   medium   600–839 small tablets, foldables navigation rail, 2 columns
///   expanded ≥ 840   large tablets            navigation rail, 2–3 columns
///
/// Screens stay full-bleed (app bar, bottom bars) but centre their scrolling
/// content within [maxContentWidth] so lines and cards don't stretch across
/// a tablet.
class AppLayout {
  static const double medium = 600;
  static const double expanded = 840;

  /// Lists, results and detail pages on tablets.
  static const double maxContentWidth = 840;

  /// Single-column forms (login, IP config).
  static const double maxFormWidth = 480;

  /// Dialogs.
  static const double maxDialogWidth = 420;

  /// Bottom sheets: full width on phones, centred column on tablets.
  static const double maxSheetWidth = 640;

  static bool isCompact(double width) => width < medium;
  static bool isTablet(double width) => width >= medium;

  /// Columns for card lists (appointments, results) at [width]. Capture
  /// grids size by tile width instead (max extent ~240dp).
  static int gridColumns(double width) {
    if (width >= expanded) return 3;
    if (width >= medium) return 2;
    return 1;
  }

  /// Horizontal page gutter at [width].
  static double gutter(double width) => width >= medium ? 24 : 16;
}
