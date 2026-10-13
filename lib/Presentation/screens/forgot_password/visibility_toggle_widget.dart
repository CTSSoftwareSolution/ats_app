import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';

Widget visibilityToggle({required bool obscured, required VoidCallback onPressed}) {
  return IconButton(
    color: textSecondary,
    tooltip: obscured ? "Show password" : "Hide password",
    onPressed: onPressed,
    icon: Icon(
      obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
      size: 20,
    ),
  );
}