import 'package:flutter/material.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';

class ValidationDialog {
  static void show({
    required BuildContext context,
    required List<String> questions,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: failLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(Icons.error_outline_rounded,
                          color: fail, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Text(
                        'Evidence Required!',
                        style: TextStyle(
                          fontFamily: "Bold",
                          fontSize: 17,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Following questions marked as "No" require evidence photos:',
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
                                  size: 16,
                                  color: fail,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  q,
                                  style: AppText.caption.copyWith(
                                    color: textPrimary,
                                    fontSize: 12.5,
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
                  style: AppText.caption.copyWith(
                    color: fail,
                    fontFamily: "SemiBold",
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
