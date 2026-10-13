

import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';

/// Inline error / success banner shown above the action button.
class ForgotPasswordMessage extends StatelessWidget {
  final String? errorMessage;
  final String? successMessage;

  const ForgotPasswordMessage({super.key, this.errorMessage, this.successMessage});

  @override
  Widget build(BuildContext context) {
    final bool isError = errorMessage != null;
    final String? message = errorMessage ?? successMessage;
    if (message == null) return const SizedBox.shrink();
    final Color color = isError ? fail : pass;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md - 2),
        decoration: BoxDecoration(
          color: isError ? failLight : passLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              size: 20,
              color: color,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontFamily: "Medium", fontSize: 13, color: color, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}