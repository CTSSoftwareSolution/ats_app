import 'package:flutter/material.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';

/// Tap target that asks for an evidence photo.
class ImagePickerPrompt extends StatelessWidget {
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? boxColor;
  const ImagePickerPrompt({super.key, required this.onTap, this.titleColor, this.subtitleColor, this.iconColor, this.borderColor, this.boxColor});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    return Material(
      color: boxColor ?? surface2,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor ?? border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(Icons.add_a_photo_rounded,
                    color: iconColor ?? appColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Evidence Photo',
                      style: AppText.title.copyWith(
                          color: titleColor ?? textPrimary, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap to capture a photo',
                      style: AppText.caption.copyWith(
                          color: subtitleColor ?? textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: iconColor ?? textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
