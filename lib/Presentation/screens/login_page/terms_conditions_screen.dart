import 'package:flutter/material.dart';

import '../../../utilities/app_theme.dart';
import '../../../utilities/color_data.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.lg,
        ),
        child: GestureDetector(
          onTap: () async {},
          child: const Text.rich(
            TextSpan(
              text: "By continuing, you agree to our\n",
              children: [
                TextSpan(
                  text: "Terms & Conditions & Privacy Policy",
                  style: TextStyle(
                    fontFamily: "SemiBold",
                    color: whiteColor,
                    decoration: TextDecoration.underline,
                    decorationColor: whiteColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Medium",
              fontSize: 12.5,
              color: textWhiteSub,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
