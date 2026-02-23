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


  static String? userNameEmailValidation(String value) {
    if (value.isEmpty) {
      return "Please Enter your username or email";
    }
    if (!RegExp(r'^[a-z0-9._]+@[a-z]+\.[a-z]').hasMatch(value)) {
      return "Enter valid email id !";
    }
    return null;
  }

  static String? globalValidation(String value) {
    if (value.isEmpty) {
      return 'This field is required!';
    }
    return null;
  }


  static String? validateIpAddress(String value) {
    if (value.isEmpty) {
      return 'Please enter an IP address';
    }

    String input = value.trim();

    // Match IPv4 + Port (example: 192.168.1.1:8080)
    final ipv4WithPortPattern =
    RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}):(\d{1,5})$');

    final match = ipv4WithPortPattern.firstMatch(input);

    if (match == null) {
      return 'Enter a valid IPv4 address with port (e.g., 192.168.1.1:8080)';
    }

    // Validate IP octets
    for (int i = 1; i <= 4; i++) {
      String octet = match.group(i)!;
      int? octetValue = int.tryParse(octet);

      if (octetValue == null) return 'Invalid IP address';
      if (octetValue < 0 || octetValue > 255) {
        return 'IP octets must be between 0-255';
      }
      if (octet.length > 1 && octet.startsWith('0')) {
        return 'Remove leading zeros from IP';
      }
    }

    // Validate Port
    String portStr = match.group(5)!;
    int? port = int.tryParse(portStr);

    if (port == null) return 'Invalid port number';
    if (port < 1 || port > 65535) {
      return 'Port must be between 1 and 65535';
    }

    return null;
  }



}
