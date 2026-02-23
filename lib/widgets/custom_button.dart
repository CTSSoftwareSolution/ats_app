import 'package:flutter/material.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;
  final Color foregroundColor, backgroundColor;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final double fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final String? fontFamily;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPress,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.shape,
    this.side,
    this.width,
    this.height,
    this.fontFamily,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: shape,
          side: side,
        ),
        child: CustomText(
          text: buttonText,
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: fontFamily,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
