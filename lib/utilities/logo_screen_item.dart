import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'color_data.dart';
import 'image_data.dart';

class LogoScreenItem extends StatelessWidget {
  const LogoScreenItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImage(image: appLogoImage, scale: 4),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          "ATS\nCORPORATION",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Black",
            color: whiteColor,
            height: 1.15,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          "SCAN, DETECT DRIVE SAFE",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontFamily: "SemiBold",
            color: textWhiteSub,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}
