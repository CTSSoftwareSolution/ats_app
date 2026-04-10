import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

import 'loader_painter.dart';

class CustomProgressIndicator extends StatefulWidget {
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final int dotCount;

  const CustomProgressIndicator({super.key,
    this.size = 40,
    this.dotCount = 9,
    this.activeColor = appColor,
    this.inactiveColor = whiteColor,});

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> with SingleTickerProviderStateMixin{

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        height: 10,
        width: double.infinity,
        child: AnimatedBuilder(
            animation: controller,
          builder: (_,_) {
            return CustomPaint(
              size: Size.square(widget.size),
              painter: LoaderPainter(
                progress: controller.value,
                dotCount: widget.dotCount,
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
              ),
            );
          }
        ),
      ),
    );
  }
}
