import 'package:flutter/material.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(color: appColor, strokeWidth: 3),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Fetching Inspection Questions...',
              textAlign: TextAlign.center,
              style: AppText.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
