
import 'package:flutter/widgets.dart';

/// Use Option 2 if you want the simplest reusable approach.

extension ResponsiveExt on BoxConstraints {
  bool get isTablet => maxWidth >= 600;
  double get contentMaxWidth => isTablet ? 520 : double.infinity;
  double get horizontalPadding => isTablet ? 40 : 30;
}

