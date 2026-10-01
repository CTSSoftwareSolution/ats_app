import 'package:flutter/material.dart';

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
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: i <= currentStep ? appColor : border,
                    borderRadius: BorderRadius.circular(3),
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
