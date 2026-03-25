import 'dart:io';
import 'dart:ui';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/video_preview_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../image_processing/MediaPicker/file_provider.dart';

class UploadImageContainer extends StatelessWidget {
  final VoidCallback onTap;
  final int index;
  final bool isTablet;
  final double borderRadius;
  final double iconSize;
  final double iconScale;
  final double buttonHeight;
  final double buttonWidth;
  final double width;
  final String text;
  final bool isVideo;



  const UploadImageContainer({
    super.key,
    required this.onTap,
    required this.index,
    required this.isTablet,
    required this.width,
    required this.isVideo,
    this.borderRadius = 20.0,
    this.iconSize = 52,
    this.iconScale = 5.5,
    this.buttonHeight = 32.0,
    this.buttonWidth = 110,
    this.text = "Tap to capture image",

  });

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    final file = isVideo ? (index < fileProvider.videos.length
        ? fileProvider.videos[index]
        : null) : fileProvider.getImage(index);

    final double height = isTablet ? 130.0 : 150.0;
    return GestureDetector(
      onTap: file == null ? onTap : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: appColor.withValues(alpha:0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFF9BA8C3).withValues(alpha:0.10),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        ),
        child: file != null
            ? Stack(
          key: ValueKey(file.path),
          fit: StackFit.expand,
          children: [
            isVideo ?
            VideoPreviewWidget(path: file.path,) :
            Image.file(
              File(file.path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: height,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.90),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_rounded, size: 12, color: appColor),
                      4.width,
                      CustomText(
                        text: "Change",
                        fontSize: 11,
                        fontFamily: "Bold",
                        textColor: appColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
            : Stack(
          key: const ValueKey('empty'),
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DashedBorderPainter(color: appColor, radius: borderRadius),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appColor.withValues(alpha: 0.05),
                    appColor.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          appColor.withValues(alpha: 0.16),
                          appColor.withValues(alpha: 0.07),
                        ],
                      ),
                    ),
                    child: Center(
                      child: CustomImage(image: uploadIcon, scale: iconScale),
                    ),
                  ),
                  12.height,
                  CustomText(
                    text: text,
                    fontSize: 12,
                    fontFamily: "Medium",
                    textColor: const Color(0xFF9AA5C0),
                  ),
                  8.height,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          appColor,
                          appColor.withValues(alpha: 0.78),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: appColor.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      height: buttonHeight,
                      width: buttonWidth,
                      buttonText: "Upload",
                      onPress: onTap,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      fontSize: 13.0,
                      fontFamily: "Bold",
                    ),
                  ),
                ],
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha:0.30)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 5;
    //const double radius = 20;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        Radius.circular(radius),
      ));

    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final extractPath =
        metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius ;
}