/// Corner radius scale. Kept deliberately small: corners soften edges, they
/// aren't decoration.
///
/// xs   – progress bars, tiny indicators, checkbox
/// sm   – static chips, tags, thumbnails inside cards, number plate
/// md   – buttons, inputs, filter chips, capture slots, icon tiles, snackbars
/// lg   – cards, list groups
/// xl   – dialogs and the top of bottom sheets
/// full – status badges and pills (stadium)
class AppRadius {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 999;
}
