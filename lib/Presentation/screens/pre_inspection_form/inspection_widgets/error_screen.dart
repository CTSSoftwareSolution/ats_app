import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../provider/inspection_form_provider.dart';

class ErrorScreen extends StatelessWidget {
  final InspectionFormProvider provider;
  const ErrorScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: failLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded, size: 30, color: fail),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Failed to Load',
              textAlign: TextAlign.center,
              style: AppText.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              constraints: const BoxConstraints(maxHeight: 160),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: border),
              ),
              child: SingleChildScrollView(
                child: Text(
                  provider.errorMessage,
                  style: AppText.bodySecondary.copyWith(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Check Flutter console for full stack trace',
              textAlign: TextAlign.center,
              style: AppText.caption,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: ()=>provider.fetchInspectionData(),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
