import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'color_data.dart';
import 'image_data.dart';

class LogoScreenItem extends StatelessWidget {
  const LogoScreenItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        CustomImage(image: appLogoImage, scale: 4),
        5.height,
        CustomText(
          text: "ATS\nCORPORATION",
          fontSize: 24,
          fontFamily: "Black",
          textColor: whiteColor,
          textAlign: TextAlign.center,
        ),
        CustomText(
          text: "SCAN, DETECT DRIVE SAFE",
          fontSize: 14,
          fontFamily: "Regular",
          textColor: whiteColor,
        ),
      ],
    );
  }
}
