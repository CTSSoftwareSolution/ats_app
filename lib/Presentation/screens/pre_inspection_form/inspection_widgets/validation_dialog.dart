import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../../utilities/new_app_theme/app_layout.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/new_app_ui/app_icon_tile.dart';
import '../../../../widgets/new_app_ui/primary_button.dart';

class ValidationDialog {
  static void show({
    required BuildContext context,
    required List<String> questions,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppLayout.maxDialogWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.dialog,
              AppSpacing.dialog,
              AppSpacing.dialog,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppIconTile(
                      icon: Icons.error_outline_rounded,
                      color: fail,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Evidence required',
                        style: AppText.dialogTitle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'These questions were answered "No" and need an evidence photo:',
                  style: AppText.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: surface2,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: questions.map((q) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  size: AppIconSize.sm,
                                  color: fail,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  q,
                                  style: AppText.caption.copyWith(
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Please add photos for all failed inspections before submitting.',
                  style: AppText.tag.copyWith(color: fail),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Got it',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
