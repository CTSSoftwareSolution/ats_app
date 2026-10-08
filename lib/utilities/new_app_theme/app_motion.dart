import 'package:flutter/animation.dart';

/// Motion tokens. Animation only explains a change of state (selection,
/// expand/collapse, progress); nothing animates for decoration.
///
/// fast     – selection feedback: chips, tabs, navigation pills, toggles
/// standard – expand / collapse, content swaps
class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 200);
  static const Curve curve = Curves.easeOutCubic;
}
