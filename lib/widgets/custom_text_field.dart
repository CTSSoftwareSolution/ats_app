import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilities/color_data.dart';




class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  final bool readOnly;
  final double? height;
  final double? width;
  final double? borderWidth;
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
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;
  final TextStyle hintStyle;
  final ValueChanged<String>? onChanged;
  final TextAlign? textAlign;

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
    this.errorColor

  });

  @override
  Widget build(BuildContext context) {
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
        style: TextStyle(
          color: blackColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        textAlign: textAlign ?? TextAlign.start,
        cursorColor: appColor,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          fillColor: fillColor,
          filled: true,
          hintTextDirection: TextDirection.ltr,
          hintStyle: hintStyle,
          focusColor: appColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColor, width: borderWidth ?? 1),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          disabledBorder: disabledBorder,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColor, width: borderWidth ?? 1),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: appColor, width: borderWidth ?? 1),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
         errorBorder: OutlineInputBorder(
           borderSide: BorderSide(color: appColor, width: borderWidth ?? 1),
           borderRadius: BorderRadius.all(Radius.circular(5.0)),
         ),
         errorStyle: TextStyle(color: errorColor ),
          hintText: hint,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
