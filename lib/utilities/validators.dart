import 'package:flutter/material.dart';

class Validators {

  static String? emailValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return "This field is required !";
    }
    if (!RegExp(r'^[a-z0-9._]+@[a-z]+\.[a-z]').hasMatch(value)) {
      return "Enter valid email id !";
    }
    return null;
  }

  static String? mobileValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return "This field is required !";
    }
    if (value.length != 10) {
      return "Enter 10 digit number !";
    }
    return null;
  }

  static String? textValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return "This field is required !";
    }
    if (value.length < 2) {
      return "Please enter at least 2 characters !";
    }
    return null;
  }

  static String? oldPasswordValidation(String value, BuildContext context)
  {
    if (value.isEmpty) {
      return "Please Enter Old Password";
    }
    return null;
  }
  static String? newPasswordValidation(String value, BuildContext context)
  {
    if (value.isEmpty) {
      return "Please Enter New Password";
    }
    final pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return "Password must have 8+ chars, include upper, lower, number & special char";
    }
    return null;
  }

  static String? confirmPasswordValidation(String value, BuildContext context , String newPasswordController)
  {
    if (value.isEmpty)
    {
      return "Please Enter Confirm Password";
    }
    // final pattern =
    //     r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$';
    // if (!RegExp(pattern).hasMatch(value)) {
    //   return "Password must have 8+ chars, include upper, lower, number & special char";
    // }
    if(value!=newPasswordController)
    {
      return "Confirm password must be match with new password";

    }
    return null;
  }

  static String? userNameValidation(String value, BuildContext context)
  {
    if (value.isEmpty) {
      return "Please Enter Username";
    }
    return null;
  }


  static String? passwordValidation(String value, BuildContext context)
  {
    if (value.isEmpty) {
      return "Please Enter Password";
    }
    return null;
  }

  static String? otpValidation(String value, BuildContext context) {
    String trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return "Please enter OTP";
    }
    if (trimmedValue.length != 4) {
      return "OTP must be exactly 4 digits";
    }
    if (!RegExp(r'^[0-9]{4}$').hasMatch(trimmedValue)) {
      return "OTP must contain only numbers";
    }
    return null;
  }


  static String? userNameEmailValidation(String value)
  {
    if (value.isEmpty) {
      return "Please Enter your username or email";
    }
    if (!RegExp(r'^[a-z0-9._]+@[a-z]+\.[a-z]').hasMatch(value)) {
      return "Enter valid email id !";
    }
  }

  static String? globalValidation(String value) {
    if (value.isEmpty) {
      return 'This field is required!';
    }
    return null;
  }
}
