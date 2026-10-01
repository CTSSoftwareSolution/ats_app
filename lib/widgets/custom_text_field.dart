import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilities/app_theme.dart';
import '../utilities/color_data.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  final bool readOnly;
  final double? height;
  final double? width;
  final double? borderWidth;
  final Color? borderColor;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputBorder? disabledBorder;
  final TextInputType? keyboardType;
  final bool? enable;
  final bool? obscureText;
  final Color? fillColor;
  final Color? errorColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;
  final TextStyle hintStyle;
  final ValueChanged<String>? onChanged;
  final TextAlign? textAlign;
  final InputBorder? focusedErrorBorder;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.hintStyle,
    this.onChanged,
    this.onTap,
    required this.readOnly,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
    this.contentPadding = EdgeInsets.zero,
    this.height,
    this.suffixIcon,
    this.prefixIcon,
    this.minLines,
    this.width,
    this.maxLines,
    this.enable = true,
    this.fillColor,
    this.obscureText = false,
    required this.textCapitalization,
    this.disabledBorder,
    this.textAlign,
    this.borderWidth,
    this.borderColor,
    this.errorColor,
    this.focusedErrorBorder,
    this.cursorColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    OutlineInputBorder outline(Color color, double width) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );
    final restingWidth = borderWidth ?? 1;

    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        textCapitalization: textCapitalization,
        obscureText: obscureText!,
        validator: validator,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        onTap: onTap,
        onChanged: onChanged,
        enabled: enable,
        controller: controller,
        readOnly: readOnly,
        minLines: minLines,
        maxLines: maxLines,
        style: const TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontFamily: "SemiBold",
        ),
        textAlign: textAlign ?? TextAlign.start,
        cursorColor: cursorColor ?? appColor,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          fillColor: fillColor ?? surface,
          filled: true,
          hintTextDirection: TextDirection.ltr,
          hintStyle: hintStyle,
          focusColor: appColor,
          enabledBorder: outline(borderColor ?? border, restingWidth),
          disabledBorder: disabledBorder ?? outline(border, restingWidth),
          focusedBorder: outline(borderColor ?? appColor, 1.5),
          focusedErrorBorder: focusedErrorBorder ?? outline(errorColor ?? fail, 1.5),
          border: outline(borderColor ?? border, restingWidth),
          errorBorder: outline(errorColor ?? fail, restingWidth),
          errorStyle: TextStyle(color: errorColor ?? fail, fontSize: 12),
          hintText: hint,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
