import 'dart:io';
import 'dart:ui';
import 'package:ats_app/Presentation/provider/MediaPicker/file_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadImageContainer extends StatelessWidget {
  final VoidCallback onTap;
  final int index;
  final bool isTablet;
  const UploadImageContainer({
    super.key,
    required this.onTap,
    required this.index,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final image = context.watch<FileProvider>().getImage(index);
    final double height = isTablet ? 130.0 : 150.0;
    return GestureDetector(
      onTap: image == null ? onTap : null,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: appColor.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFF9BA8C3).withOpacity(0.10),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: image != null
          // ── Uploaded image view ──────────────────────────
              ? Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(image.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: height,
              ),
              // Overlay gradient at bottom
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
                        Colors.black.withOpacity(0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Re-upload chip
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_rounded,
                            size: 12, color: appColor),
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
          // ── Empty / upload state ─────────────────────────
              : Stack(
            children: [
              // Dashed border effect via custom painter
              Positioned.fill(
                child: CustomPaint(
                  painter: _DashedBorderPainter(color: appColor),
                ),
              ),
              // Subtle gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      appColor.withOpacity(0.05),
                      appColor.withOpacity(0.02),
                    ],
                  ),
                ),
              ),
              // Center content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon circle
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appColor.withOpacity(0.16),
                            appColor.withOpacity(0.07),
                          ],
                        ),
                      ),
                      child: Center(
                        child: CustomImage(image: uploadIcon, scale: 5.5),
                      ),
                    ),
                    12.height,
                    CustomText(
                      text: "Tap to capture image",
                      fontSize: 12,
                      fontFamily: "Medium",
                      textColor: const Color(0xFF9AA5C0),
                    ),
                    8.height,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appColor,
                            appColor.withOpacity(0.78),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: appColor.withOpacity(0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomButton(
                        height: 32.0,
                        width: 110.0,
                        buttonText: "Upload",
                        onPress: onTap,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
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
    );
  }
}

// Dashed border painter
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.30)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 5;
    const double radius = 20;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        const Radius.circular(radius),
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
      oldDelegate.color != color;
}