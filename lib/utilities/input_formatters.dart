import 'package:flutter/services.dart';

class InputFormatters {
  static List<TextInputFormatter> get normalText => [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]")),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    LengthLimitingTextInputFormatter(50),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get textWithNum => [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 ]")),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get textWithMarathi => [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\u0900-\u097F\s]')),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];
  static List<TextInputFormatter> get textWithMarathiAndNum => [
    FilteringTextInputFormatter.allow(
        RegExp(r'[a-zA-Z0-9\u0900-\u097F\s]')),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get textWithNumAndSpecialChar => [
    FilteringTextInputFormatter.allow(
      RegExp(r"[a-zA-Z0-9\s,.\-/#&()]"),
    ),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get textWithMarathiAndSpecChar => [
    FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z0-9\u0900-\u097F\s,.\-/#&()]'),
    ),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get mobileNumber => [
    FilteringTextInputFormatter.deny(' '),
    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    FilteringTextInputFormatter.deny(RegExp(r'^0+')),
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get otp => [
    FilteringTextInputFormatter.digitsOnly,
    FilteringTextInputFormatter.deny(' '),
    LengthLimitingTextInputFormatter(4),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get spaceNotAllowed => [
    FilteringTextInputFormatter.deny(' '),
    LengthLimitingTextInputFormatter(20),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get pinController => [
    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    FilteringTextInputFormatter.deny(' '),
    LengthLimitingTextInputFormatter(6),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get specialRestrictions => [
    FilteringTextInputFormatter.deny(' '),
    LengthLimitingTextInputFormatter(50),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get textWithMaxChar => [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 ]")),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    LengthLimitingTextInputFormatter(50),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get descriptionValidation => [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 ]")),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    LengthLimitingTextInputFormatter(200),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get addressValidation => [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s,.\-/#&()]"),),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
    LengthLimitingTextInputFormatter(200),
    FilteringTextInputFormatter.deny(
      RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
    ),
  ];

  static List<TextInputFormatter> get ipAddressValidation => [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    FilteringTextInputFormatter.deny(RegExp(r'\.\.')),
    FilteringTextInputFormatter.deny(RegExp(r"  ")),
  ];

}
