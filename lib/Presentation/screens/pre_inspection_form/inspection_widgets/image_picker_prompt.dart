import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/new_app_ui/app_icon_tile.dart';
import '../../../../widgets/new_app_ui/app_spinner.dart';

/// Tap target that asks for an evidence photo. While [uploading], it shows
/// progress and ignores taps.
class ImagePickerPrompt extends StatelessWidget {
  final VoidCallback onTap;
  final bool uploading;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? boxColor;
  const ImagePickerPrompt({
    super.key,
    required this.onTap,
    this.uploading = false,
    this.titleColor,
    this.subtitleColor,
    this.iconColor,
    this.borderColor,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    final tint = iconColor ?? appColor;
    return Semantics(
      button: !uploading,
      label: uploading
          ? 'Uploading evidence photo'
          : 'Add evidence photo, required',
      excludeSemantics: true,
      child: Material(
        color: boxColor ?? surface,
        borderRadius: radius,
        child: InkWell(
          onTap: uploading ? null : onTap,
          borderRadius: radius,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: borderColor ?? border),
            ),
            child: Row(
              children: [
                uploading
                    ? const SizedBox.square(
                        dimension: 40,
                        child: Center(child: AppSpinner.small()),
                      )
                    : AppIconTile(icon: Icons.add_a_photo_outlined, color: tint),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        uploading ? 'Uploading photo…' : 'Add evidence photo',
                        style: AppText.label.copyWith(
                          color: uploading ? textPrimary : titleColor ?? tint,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        uploading
                            ? 'Keep this screen open until it finishes'
                            : 'Required for a failed check · opens the camera',
                        style: AppText.caption.copyWith(
                          color: subtitleColor ?? textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!uploading)
                  Icon(Icons.chevron_right_rounded, color: tint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
