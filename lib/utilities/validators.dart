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


  static String? validateIpAddress(String value) {
    if (value.isEmpty) {
      return 'Please enter an IP address';
    }

    // Trim whitespace
    String input = value.trim();

    // Remove http:// or https:// for validation
    String cleanValue = input.replaceAll(RegExp(r'^https?://'), '');

    // Split by colon to separate IP/domain from port and path
    List<String> parts = cleanValue.split(':');

    if (parts.isEmpty) {
      return 'Invalid format';
    }

    String ipOrDomain = parts[0];
    String? portAndPath;

    if (parts.length > 1) {
      portAndPath = parts.sublist(1).join(':');
    }

    // Validate IP address format
    final ipPattern = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$');
    final ipMatch = ipPattern.firstMatch(ipOrDomain);

    if (ipMatch != null) {
      // It's an IP address - validate octets
      for (int i = 1; i <= 4; i++) {
        String octet = ipMatch.group(i)!;
        int? octetValue = int.tryParse(octet);

        if (octetValue == null) {
          return 'Invalid IP address';
        }

        if (octetValue < 0 || octetValue > 255) {
          return 'IP octets must be 0-255 (found: $octetValue)';
        }

        // Check for leading zeros (e.g., 192.168.001.1)
        if (octet.length > 1 && octet.startsWith('0')) {
          return 'Remove leading zeros from IP';
        }
      }
    } else {
      // Check if it's a valid domain name
      final domainPattern = RegExp(
        r'^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
      );

      if (!domainPattern.hasMatch(ipOrDomain)) {
        return 'Enter valid IP or domain name';
      }

      // Additional domain validation
      if (ipOrDomain.length > 253) {
        return 'Domain name too long';
      }

      // Check each label length
      List<String> labels = ipOrDomain.split('.');
      for (String label in labels) {
        if (label.length > 63) {
          return 'Domain label too long';
        }
        if (label.isEmpty) {
          return 'Invalid domain format';
        }
      }
    }

    // Validate port if present
    if (portAndPath != null) {
      // Extract port (everything before the first '/')
      String portPart = portAndPath.split('/')[0];

      if (portPart.isNotEmpty) {
        int? port = int.tryParse(portPart);

        if (port == null) {
          return 'Port must be a number';
        }

        if (port < 1 || port > 65535) {
          return 'Port must be 1-65535 (found: $port)';
        }
      }
    }

    // Additional checks
    if (cleanValue.contains('..')) {
      return 'Invalid format (consecutive dots)';
    }

    if (cleanValue.contains('::')) {
      return 'Invalid format (consecutive colons)';
    }

    if (cleanValue.startsWith('.') || cleanValue.endsWith('.')) {
      return 'Cannot start/end with dot';
    }

    if (cleanValue.startsWith(':')) {
      return 'Cannot start with colon';
    }

    return null;
  }

}
