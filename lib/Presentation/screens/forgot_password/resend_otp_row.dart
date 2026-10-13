import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';

class ResendOtpRow extends StatelessWidget {
  final int secondsLeft;
  final VoidCallback? onResend;

  const ResendOtpRow({super.key, required this.secondsLeft, required this.onResend});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Didn't receive the code?",
          style: TextStyle(fontFamily: "Medium", fontSize: 13, color: textSecondary),
        ),
        TextButton(
          onPressed: onResend,
          style: TextButton.styleFrom(
            foregroundColor: appColor,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            minimumSize: const Size(0, 36),
          ),
          child: Text(
            secondsLeft > 0 ? "Resend in 00:${secondsLeft.toString().padLeft(2, '0')}" : "Resend OTP",
            style: const TextStyle(fontFamily: "SemiBold", fontSize: 13),
          ),
        ),
      ],
    );
  }
}