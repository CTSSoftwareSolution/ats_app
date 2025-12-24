import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

class StepperPainter extends CustomPainter {
  final int totalStep;
  final int currentStep;

  StepperPainter({
    required this.totalStep,
    required this.currentStep,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 6;
    final double spacing = size.width / (totalStep - 1);
    final double centerY = size.height / 2;

    final Paint activeLinePaint = Paint()
      ..color = appColor
      ..strokeWidth = 2;

    final Paint inactiveLinePaint = Paint()
      ..color = stepperInactiveColor
      ..strokeWidth = 2;


    final Paint activeDotPaint = Paint()
      ..color = appColor;

    final Paint inactiveDotPaint = Paint()
      ..color = stepperInactiveColor;

    for (int i = 0; i < totalStep; i++) {
      final double x = spacing * i;


      if (i < totalStep - 1) {
        canvas.drawLine(
          Offset(x + radius, centerY),
          Offset(x + spacing - radius, centerY),
          i < currentStep ? activeLinePaint : inactiveLinePaint,
        );
      }


      canvas.drawCircle(
        Offset(x, centerY),
        radius,
        i <= currentStep ? activeDotPaint : inactiveDotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StepperPainter oldDelegate) {
    return oldDelegate.currentStep != currentStep ||
        oldDelegate.totalStep != totalStep;
  }
}
