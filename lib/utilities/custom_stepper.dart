import 'package:ats_app/utilities/stepper_painter.dart';
import 'package:flutter/cupertino.dart';

class CustomStepper extends StatelessWidget {
  final int totalStep;
  final int currentStep;


  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.totalStep,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        height: 15,
        width: double.infinity,
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
