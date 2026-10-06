import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'color_data.dart';
import 'image_data.dart';
import 'new_app_theme/app_spacing.dart';
import 'new_app_theme/app_text.dart';

class LogoScreenItem extends StatelessWidget {
  const LogoScreenItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'ATS Corporation. Scan, detect, drive safe.',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImage(image: appLogoImage, scale: 4),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            "ATS\nCORPORATION",
            textAlign: TextAlign.center,
            style: AppText.display,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "SCAN, DETECT DRIVE SAFE",
            textAlign: TextAlign.center,
            style: AppText.overline.copyWith(
              fontFamily: "SemiBold",
              fontSize: 12,
              color: textWhiteSub,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
