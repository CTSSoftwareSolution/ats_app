
import 'package:flutter/widgets.dart';

/// Use Option 2 if you want the simplest reusable approach.

extension ResponsiveExt on BoxConstraints {
  bool get isTablet => maxWidth >= 600;
  double get contentMaxWidth => isTablet ? 540 : double.infinity;
  double get horizontalPadding => isTablet ? 30 : 15;
  double get contentMaxHeight => isTablet ? 70 : 60;




}

