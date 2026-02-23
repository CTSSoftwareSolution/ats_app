import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? decorationColor;
  final int? maxLine;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final VoidCallback? click;
  final TextDecoration? decoration;
  final bool? softWrap;
  final double? letterSpacing;

  const CustomText({
    super.key,
    required this.text,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.maxLine,
    this.textAlign,
    this.textColor,
    this.overflow,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.decoration,
    this.click,
    this.letterSpacing,
    this.softWrap,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding!,
        right: rightPadding!,
        top: topPadding!,
        bottom: bottomPadding!,
      ),
      child: InkWell(
        onTap: click,
        child: Text(
          text,
          maxLines: maxLine,
          textAlign: textAlign,
          softWrap: softWrap,
          style: TextStyle(
            letterSpacing: letterSpacing,
            decoration: decoration,
            decorationColor: decorationColor,
            overflow: overflow,
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
