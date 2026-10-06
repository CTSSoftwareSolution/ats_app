import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Plain text: there is no Terms page to open yet, so the policy name is
    // emphasised rather than styled as a link.
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.lg,
        ),
        child: Text.rich(
          const TextSpan(
            text: "By continuing, you agree to our\n",
            children: [
              TextSpan(
                text: "Terms & Conditions & Privacy Policy",
                style: TextStyle(fontFamily: "SemiBold", color: textWhite),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppText.caption.copyWith(color: textWhiteSub, height: 1.6),
        ),
      ),
    );
  }
}
