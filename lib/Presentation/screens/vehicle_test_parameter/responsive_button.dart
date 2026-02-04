import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../widgets/custom_button.dart';

class ResponsiveButton extends StatelessWidget {
  final double width;
  final String buttonText;
  final VoidCallback onPress;
  const ResponsiveButton({super.key, required this.width, required this.buttonText, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: CustomButton(
        width: width,
        height: 50.0,
        buttonText: buttonText,
        onPress: onPress,
        backgroundColor: appColor,
        foregroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(
            Radius.circular(30.0),
          ),
        ),
        fontSize: 20.0,
        fontFamily: "Bold",
      ),
    );
  }
}
