import 'package:flutter/widgets.dart';

import '../color_data.dart';

/// Elevation tokens. The app is flat: surfaces are separated by hairline
/// borders ([border]), not shadows.
///
/// none    – every card, sheet, dialog, app bar and bottom bar
/// overlay – only things that float over live content with no scrim behind
///           them (popup menus, camera controls over the preview)
class AppShadow {
  static const List<BoxShadow> none = <BoxShadow>[];

  static const List<BoxShadow> overlay = <BoxShadow>[
    BoxShadow(color: Color(0x140D1B3E), blurRadius: 12, offset: Offset(0, 4)),
  ];

  /// Material elevation equivalent of [overlay], for widgets that take an
  /// `elevation` instead of a shadow list.
  static const double overlayElevation = 2;

  /// Shadow colour used with [overlayElevation].
  static const Color color = navy;
}
