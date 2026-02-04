import 'package:ats_app/utilities/stepper_painter.dart';
import 'package:flutter/cupertino.dart';

class CustomStepper extends StatelessWidget {
  final int totalStep;
  final int currentStep;
  final double width;


  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.totalStep,
    required this.width

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        height: 15,
        width: width,
        child: CustomPaint(
          painter: StepperPainter(
            totalStep: totalStep,
            currentStep: currentStep,
          ),
        ),
      ),
    );
  }
}
