import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../utilities/color_data.dart';
import '../utilities/new_app_theme/app_icon_size.dart';
import '../utilities/new_app_theme/app_radius.dart';
import '../utilities/new_app_theme/app_spacing.dart';
import '../utilities/new_app_theme/app_text.dart';
import 'new_app_ui/app_state_view.dart';
import 'new_app_ui/app_toast.dart';

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

  /// Passing notice or hint ("2 photos left to capture").
  static message(String msg) {
    showAppToast(msg);
  }

  /// Passing confirmation of a finished action ("Result updated").
  static success(String msg) {
    showAppToast(msg, tone: AppToastTone.success);
  }

  /// Passing failure the inspector should read ("Couldn't update result").
  static errorMessage(String msg) {
    showAppToast(msg, tone: AppToastTone.error);
  }

  static internetMessage({required String msg, required BuildContext context}) {
    _showSnackBar(
      context,
      icon: Icons.wifi_off_rounded,
      color: fail,
      message: "No Internet",
    );
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
            Icon(icon, color: textWhite, size: AppIconSize.lg),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: AppText.label.copyWith(color: textWhite),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
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
          vertical: AppSpacing.md,
        ),
        elevation: 0,
        duration: duration,
      ),
    );
  }
}
