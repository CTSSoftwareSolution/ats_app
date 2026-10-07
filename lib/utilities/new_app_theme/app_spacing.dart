/// 4dp-based spacing scale. Use these instead of raw numbers for padding,
/// gaps and margins.
class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Gap between an icon and its label inside chips, pills and meta rows.
  static const double iconGap = 6;

  /// Standard horizontal page gutter.
  static const double page = 16;

  /// Inner padding of cards and list tiles.
  static const double card = 16;

  /// Inner padding of dialogs and bottom sheets.
  static const double dialog = 20;

  /// Gap between cards in a list and between form rows.
  static const double listGap = md;

  /// Gap between unrelated sections of a page.
  static const double section = xl;

  /// Height of primary/secondary action buttons (glove-friendly).
  static const double buttonHeight = 52;

  /// Height of compact inline buttons ("Retest", "Retry" on a card) and
  /// filter chips. Their tap area is padded to [minTouchTarget].
  static const double compactHeight = 40;

  /// Height of single-line text inputs and the search field.
  static const double inputHeight = 48;

  /// Inner padding of text inputs (gives the 48dp height with [AppText.input]).
  static const double inputPadding = 14;

  /// Minimum size of anything tappable (Material / WCAG guidance).
  static const double minTouchTarget = 48;
}
