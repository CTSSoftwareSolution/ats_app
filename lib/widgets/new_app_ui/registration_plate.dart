import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Number-plate styled registration number. The number is never truncated:
/// when space is tight it scales down to fit instead of ellipsizing, so the
/// inspector can always read the full registration.
class RegistrationPlate extends StatelessWidget {
  final String number;
  final double fontSize;

  const RegistrationPlate({
    super.key,
    required this.number,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Registration $number',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: textPrimary, width: 1.4),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            number.toUpperCase(),
            maxLines: 1,
            softWrap: false,
            style: AppText.plate.copyWith(fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
