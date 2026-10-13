import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';

class ForgotPasswordFieldLabel extends StatelessWidget {
  final String text;

  const ForgotPasswordFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm - 2),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "SemiBold",
          fontSize: 13,
          color: textSecondary,
        ),
      ),
    );
  }
}