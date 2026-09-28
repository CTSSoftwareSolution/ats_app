import 'dart:io';
import 'dart:ui';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/video_preview_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/app_ui.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../image_processing/MediaPicker/file_provider.dart';
import 'image_dialog_box.dart';

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
  final String image;
  final bool isVideo;
  final double? imageHeight;
  final double? imageWidth;



  const UploadImageContainer({
    super.key,
    required this.onTap,
    required this.index,
    required this.isTablet,
    required this.width,
    required this.isVideo,
    this.image = uploadIcon,
    this.borderRadius = 12.0,
    this.iconSize = 44,
    this.iconScale = 5.5,
    this.buttonHeight = 32.0,
    this.buttonWidth = 110,
    this.imageHeight,
    this.imageWidth,
    this.text = "Tap to capture image",

  });

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    final media = fileProvider.getMedia(index);
    final XFile? mediaFile = isVideo ? media?.video : media?.image;

    final double height = isTablet ? 130.0 : 150.0;
    final radius = BorderRadius.circular(borderRadius);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: mediaFile == null ? appColor.withValues(alpha: 0.03) : surface2,
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: mediaFile != null
              ? _buildPreview(context, mediaFile, height)
              : _buildEmpty(),
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, XFile mediaFile, double height) {
    return Stack(
      key: ValueKey(mediaFile.path),
      fit: StackFit.expand,
      children: [
        isVideo
            ? VideoPreviewWidget(path: mediaFile.path)
            : Image.file(
                File(mediaFile.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: height,
              ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          top: 8,
          left: 8,
          child: StatusBadge(
            label: 'Captured',
            color: whiteColor,
            background: pass,
            icon: Icons.check_rounded,
            dense: true,
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Labelled pills need ~160px for View + Retake (~90px for Retake alone);
              // on narrower tiles fall back to icon-only actions.
              final compact = constraints.maxWidth < (isVideo ? 90 : 160);
              return Row(
                children: [
                  if (!isVideo)
                    _OverlayAction(
                      icon: Icons.visibility_outlined,
                      label: 'View',
                      compact: compact,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => ImageDialogBox(path: mediaFile.path),
                        );
                      },
                    ),
                  const Spacer(),
                  _OverlayAction(
                    icon: isVideo ? Icons.videocam_outlined : Icons.camera_alt_outlined,
                    label: 'Retake',
                    compact: compact,
                    onTap: onTap,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Material(
      key: const ValueKey('empty'),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: CustomPaint(
          painter: _DashedBorderPainter(color: appColor, radius: borderRadius),
          child: Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentLight,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomImage(
                          image: image,
                          scale: iconScale,
                          height: imageHeight,
                          width: imageWidth,
                          color: appColor,
                        ),
                      ),
                    ),
                  ),
                  // 8.height,
                  // Text(
                  //   text,
                  //   textAlign: TextAlign.center,
                  //   maxLines: 2,
                  //   style: const TextStyle(
                  //     fontSize: 12,
                  //     fontFamily: "Medium",
                  //     color: textSecondary,
                  //   ),
                  // ),
                  8.height,
                  SizedBox(
                    height: buttonHeight,
                    width: buttonWidth,
                    child: FilledButton.icon(
                      onPressed: onTap,
                      style: FilledButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        textStyle: const TextStyle(fontSize: 12.5, fontFamily: "Bold"),
                      ),
                      icon: Icon(
                        isVideo ? Icons.videocam_rounded : Icons.camera_alt_rounded,
                        size: 15,
                      ),
                      label: Text(isVideo ? 'Record' : 'Capture'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool compact;

  const _OverlayAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: compact
                  ? const EdgeInsets.all(7)
                  : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: compact
                  ? Icon(icon, size: 16, color: appColor)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 14, color: appColor),
                        4.width,
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "Bold",
                            color: appColor,
                          ),
                        ),
                      ],
                    ),
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
      ..color = color.withValues(alpha:0.35)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 5;

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
