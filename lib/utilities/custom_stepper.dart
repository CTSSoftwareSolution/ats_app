import 'package:flutter/material.dart';
import 'package:ats_app/utilities/new_app_theme/app_spacing.dart';
import 'package:ats_app/utilities/new_app_theme/app_motion.dart';
import 'package:ats_app/utilities/new_app_theme/app_radius.dart';

import 'color_data.dart';

/// Compact segmented step indicator: one segment per step, filled in the
/// brand color up to and including [currentStep].
class CustomStepper extends StatelessWidget {
  final int totalStep;
  final int currentStep;
  final double width;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.totalStep,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step ${currentStep + 1} of $totalStep',
      child: SizedBox(
        width: width,
        height: 6,
        child: Row(
          children: [
            for (int i = 0; i < totalStep; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AnimatedContainer(
                  duration: AppMotion.standard,
                  decoration: BoxDecoration(
                    color: i <= currentStep ? appColor : border,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
