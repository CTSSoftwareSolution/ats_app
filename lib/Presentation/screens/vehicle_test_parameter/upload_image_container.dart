import 'dart:io';
import 'dart:ui';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/video_preview_widget.dart';
import 'package:ats_app/utilities/app_theme.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../image_processing/MediaPicker/file_provider.dart';
import 'image_dialog_box.dart';

/// Capture slot: a dashed placeholder until media is captured, then a
/// thumbnail with "preview" and "retake" affordances.
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
    this.borderRadius = 20.0,
    this.iconSize = 52,
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
    // Slots follow the design system radius regardless of the legacy value.
    const double radius = AppRadius.md;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: mediaFile != null ? surface2 : bg,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: mediaFile == null ? onTap : null,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            layoutBuilder: (current, previous) => Stack(
              fit: StackFit.expand,
              children: [...previous, if (current != null) current],
            ),
            child: mediaFile != null
                ? _CapturedSlot(
                    key: ValueKey(mediaFile.path),
                    path: mediaFile.path,
                    isVideo: isVideo,
                    onRetake: onTap,
                  )
                : _EmptySlot(
                    key: const ValueKey('empty'),
                    image: image,
                    text: text,
                    iconSize: iconSize,
                    iconScale: iconScale,
                    imageHeight: imageHeight,
                    imageWidth: imageWidth,
                    radius: radius,
                    onTap: onTap,
                  ),
          ),
        ),
      ),
    );
  }
}

class _CapturedSlot extends StatelessWidget {
  final String path;
  final bool isVideo;
  final VoidCallback onRetake;

  const _CapturedSlot({
    super.key,
    required this.path,
    required this.isVideo,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        isVideo
            ? VideoPreviewWidget(path: path)
            : Image.file(File(path), fit: BoxFit.cover),
        if (!isVideo)
          Positioned(
            top: 6,
            right: 6,
            child: _OverlayIconButton(
              icon: Icons.open_in_full_rounded,
              tooltip: 'Preview',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => ImageDialogBox(path: path),
                );
              },
            ),
          ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Material(
            color: surface,
            shape: const StadiumBorder(),
            elevation: 1,
            shadowColor: Colors.black26,
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: onRetake,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, size: 14, color: appColor),
                    SizedBox(width: 4),
                    Text(
                      "Retake",
                      style: TextStyle(
                        fontFamily: "SemiBold",
                        fontSize: 12,
                        color: appColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final String image;
  final String text;
  final double iconSize;
  final double iconScale;
  final double? imageHeight;
  final double? imageWidth;
  final double radius;
  final VoidCallback onTap;

  const _EmptySlot({
    super.key,
    required this.image,
    required this.text,
    required this.iconSize,
    required this.iconScale,
    required this.imageHeight,
    required this.imageWidth,
    required this.radius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: borderDark, radius: radius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Drop secondary content when the slot is short so nothing overflows.
          final showText = constraints.maxHeight >= 96;
          final showButton = constraints.maxHeight >= 136;
          final double circle = iconSize.clamp(36.0, 44.0);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: circle,
                    height: circle,
                    decoration: const BoxDecoration(
                      color: accentLight,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: CustomImage(
                      image: image,
                      scale: iconScale,
                      height: imageHeight,
                      width: imageWidth,
                      color: appColor,
                    ),
                  ),
                  if (showText) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: textSecondary),
                    ),
                  ],
                  if (showButton) ...[
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 32,
                      child: FilledButton.tonalIcon(
                        onPressed: onTap,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          backgroundColor: accentLight,
                          foregroundColor: appColor,
                          textStyle: const TextStyle(fontFamily: "SemiBold", fontSize: 12.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                        icon: const Icon(Icons.photo_camera_outlined, size: 16),
                        label: const Text("Capture"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small round translucent icon button laid over a thumbnail.
class _OverlayIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _OverlayIconButton({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 16, color: Colors.white),
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
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 4;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0.6, 0.6, size.width - 1.2, size.height - 1.2),
        Radius.circular(radius),
      ));

    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
