
import 'package:flutter/material.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../provider/inspection_form_provider.dart';

class ErrorScreen extends StatelessWidget {
  final InspectionFormProvider provider;
  const ErrorScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: failLight, shape: BoxShape.circle),
              child: const Icon(Icons.cloud_off_rounded, size: 34, color: fail),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load inspection',
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Bold",
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxHeight: 160),
              decoration: BoxDecoration(
                color: failLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: fail.withValues(alpha: 0.2)),
              ),
              child: SingleChildScrollView(
                child: Text(
                  provider.errorMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: fail,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: ()=>provider.fetchInspectionData(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
