import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utilities/color_data.dart';
import '../utilities/new_app_theme/app_radius.dart';
import '../utilities/new_app_theme/app_spacing.dart';
import '../utilities/new_app_theme/app_text.dart';
import 'new_app_ui/app_state_view.dart';

class CustomLoader {
  static showToast(
    String? message, {
    EasyLoadingToastPosition position = EasyLoadingToastPosition.center,
  }) {
    EasyLoading.showToast(message!, toastPosition: position);
  }

  static showLoader(String message) {
    EasyLoading.show(status: message, dismissOnTap: false);
  }

  static closeLoader() {
    EasyLoading.dismiss();
  }

  static message(String msg) {
    _toast(msg, background: appColor);
  }

  static errorMessage(String msg) {
    _toast(msg, background: fail);
  }

  static void _toast(String msg, {required Color background}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: background,
      textColor: whiteColor,
      fontSize: 14.0,
    );
  }

  static internetMessage({required String msg, required BuildContext context}) {
    context.showCustomSnackBar(message: "No Internet", backgroundColor: fail);
  }

  /// Inline full-area spinner; same as [AppLoadingView].
  static Widget loader({String? message}) {
    return AppLoadingView(message: message);
  }

  static showSuccessSnackBar(BuildContext context) {
    _showSnackBar(
      context,
      icon: Icons.check_circle_rounded,
      color: pass,
      title: 'Success!',
      message: 'IP address saved successfully',
    );
  }

  static showErrorSnackBar(BuildContext context) {
    _showSnackBar(
      context,
      icon: Icons.error_rounded,
      color: fail,
      title: 'Error!',
      message: 'Failed to save IP address',
    );
  }

  static showCustomErrorSnackBar(String message, BuildContext context) {
    _showSnackBar(
      context,
      icon: Icons.error_outline_rounded,
      color: fail,
      message: message,
      duration: const Duration(seconds: 4),
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textWhite, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: AppText.title.copyWith(
                        fontSize: 14,
                        color: textWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message,
                    style: AppText.bodySecondary.copyWith(color: textWhite),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        elevation: 0,
        duration: duration,
      ),
    );
  }
}
