import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../widgets/custom_text.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GestureDetector(
          onTap: () async {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  text: "By continuing, you agree to our",
                  fontSize: 14,
                  textAlign: TextAlign.center,
                  textColor: whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  text: "Terms & Conditions & Privacy Policy",
                  fontSize: 14,
                  textAlign: TextAlign.center,
                  decoration: TextDecoration.underline,
                  textColor: whiteColor,
                  decorationColor: whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
