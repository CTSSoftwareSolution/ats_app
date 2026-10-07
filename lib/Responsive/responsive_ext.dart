import 'package:flutter/widgets.dart';

import '../utilities/new_app_theme/app_layout.dart';

/// Phone / tablet helpers on layout constraints. Breakpoints live in
/// [AppLayout].
extension ResponsiveExt on BoxConstraints {
  bool get isTablet => AppLayout.isTablet(maxWidth);

  /// Width of the splash / login column.
  double get contentMaxWidth => isTablet ? 540 : double.infinity;
  double get horizontalPadding => isTablet ? 30 : 15;
  double get contentMaxHeight => isTablet ? 70 : 60;
}
