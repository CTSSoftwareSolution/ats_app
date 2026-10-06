import 'dart:io';
import 'dart:ui';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/video_preview_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import 'capture_status.dart';
import 'image_dialog_box.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/media_upload_tracker.dart';

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

  /// Queue upload state of this slot; null when the slot is not uploaded on
  /// capture (the thumbnail then shows "Captured").
  final SlotUploadState? uploadState;

  /// Re-sends the captured file; shown as "Retry" when the upload failed.
  final VoidCallback? onRetry;

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
    this.uploadState,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    final media = fileProvider.getMedia(index);
    final XFile? mediaFile = isVideo ? media?.video : media?.image;

    final double height = isTablet ? 130.0 : 150.0;
    // Slots follow the design system radius regardless of the legacy value.
    const double radius = AppRadius.md;

    final failed = mediaFile != null && uploadState == SlotUploadState.failed;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: mediaFile != null ? surface2 : bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: failed
              ? const BorderSide(color: fail, width: 1.5)
              : BorderSide.none,
        ),
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
                    uploadState: uploadState,
                    onRetry: onRetry,
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
                    isVideo: isVideo,
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
  final SlotUploadState? uploadState;
  final VoidCallback? onRetry;

  const _CapturedSlot({
    super.key,
    required this.path,
    required this.isVideo,
    required this.onRetake,
    this.uploadState,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final status = CaptureStatus.ofSlot(hasFile: true, upload: uploadState);
    final failed = status == CaptureStatus.failed && onRetry != null;
    final retakeIcon = isVideo ? Icons.videocam_outlined : Icons.photo_camera_outlined;
    return Semantics(
      container: true,
      label: '${isVideo ? 'Video' : 'Photo'}: ${status.label}',
      child: Stack(
      fit: StackFit.expand,
      children: [
        isVideo
            ? VideoPreviewWidget(path: path)
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image_outlined, color: na, size: AppIconSize.xl),
                ),
              ),
        // While uploading, dim the thumbnail and say so in the middle.
        if (status == CaptureStatus.uploading)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.35),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: textWhite),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Uploading…', style: AppText.caption.copyWith(color: textWhite)),
                ],
              ),
            ),
          ),
        Positioned(
          top: 6,
          left: 6,
          right: isVideo ? 6 : 52, // clear of the Preview button
          child: Align(alignment: Alignment.centerLeft, child: status.badge()),
        ),
        if (!isVideo)
          Positioned(
            top: 0,
            right: 0,
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
        // Pills sit 8dp from the edges; their [_PillButton] hit area extends
        // into that margin.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              if (failed)
                _PillButton(
                  icon: Icons.refresh_rounded,
                  label: "Retry",
                  color: fail,
                  onTap: onRetry!,
                ),
              const Spacer(),
              // When Retry is shown the slot is narrow, so Retake becomes icon-only.
              failed
                  ? _PillButton(
                      icon: retakeIcon,
                      tooltip: "Retake",
                      color: appColor,
                      onTap: onRetake,
                    )
                  : _PillButton(
                      icon: retakeIcon,
                      label: "Retake",
                      color: appColor,
                      onTap: onRetake,
                    ),
            ],
          ),
        ),
        if (status == CaptureStatus.uploading)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Colors.transparent,
              color: accent,
            ),
          ),
      ],
      ),
    );
  }
}

/// White pill action laid over a thumbnail (Retake / Retry).
class _PillButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final String? tooltip;
  final Color color;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    this.label,
    this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: surface,
      shape: const StadiumBorder(),
      elevation: 1,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: label == null ? 8 : 12,
            vertical: 9,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: color),
              if (label != null) ...[
                const SizedBox(width: 4),
                Text(
                  label!,
                  style: AppText.chip.copyWith(fontSize: 12, color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    final hitArea = _ExpandedHitArea(onTap: onTap, child: button);
    return tooltip == null ? hitArea : Tooltip(message: tooltip!, child: hitArea);
  }
}

class _EmptySlot extends StatelessWidget {
  final String image;
  final String text;
  final double iconSize;
  final double iconScale;
  final double? imageHeight;
  final double? imageWidth;
  final bool isVideo;
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
    this.isVideo = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${isVideo ? 'Video' : 'Photo'}: Not captured. $text',
      excludeSemantics: true,
      child: CustomPaint(
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
                          textStyle: const TextStyle(
                            fontFamily: "SemiBold",
                            fontSize: 12.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                        icon: Icon(
                            isVideo ? Icons.videocam_outlined : Icons.photo_camera_outlined,
                            size: 16),
                        label: Text(isVideo ? "Record" : "Capture"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}

/// Small round translucent icon button laid over a thumbnail.
class _OverlayIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _OverlayIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: _ExpandedHitArea(
        onTap: onTap,
        child: Material(
          color: Colors.black.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 16, color: textWhite),
            ),
          ),
        ),
      ),
    );
  }
}

/// Surrounds a small overlay control with 8dp of transparent padding that
/// also triggers [onTap], so a ~32dp control gets a 48dp touch target
/// without changing how it looks.
class _ExpandedHitArea extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _ExpandedHitArea({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: child,
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
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0.6, 0.6, size.width - 1.2, size.height - 1.2),
          Radius.circular(radius),
        ),
      );

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
