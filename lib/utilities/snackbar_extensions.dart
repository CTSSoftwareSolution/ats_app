import 'package:flutter/material.dart';

extension SnackBarExtensions on BuildContext {
  // Custom SnackBar with Helper Method
  void showCustomSnackBar({
    required String message,
    Color backgroundColor = Colors.black,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

//SnackBar for Success and Error
  void showSuccessSnackBar(String message) {
    showCustomSnackBar(
      message: message,
      backgroundColor: Colors.green,
    );
  }

  void showErrorSnackBar(String message) {
    showCustomSnackBar(
      message: message,
      backgroundColor: Colors.red,
    );
  }
}
