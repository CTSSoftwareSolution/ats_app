import '../../../widgets/new_app_ui/app_spinner.dart';
import 'dart:io';
import 'package:ats_app/utilities/new_app_theme/app_icon_size.dart';
import 'package:ats_app/utilities/new_app_theme/app_radius.dart';
import 'package:ats_app/utilities/new_app_theme/app_spacing.dart';
import 'package:ats_app/utilities/new_app_theme/app_text.dart';

import 'package:ats_app/Presentation/screens/vehicle_test_parameter/video_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../utilities/color_data.dart';

class VideoPreviewWidget extends StatefulWidget {
  final String path;

  /// Header of the full-screen player, e.g. "Front bumper · Video".
  final String? title;

  const VideoPreviewWidget({super.key, required this.path, this.title});

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {
  VideoPlayerController? videoPlayerController;

  /// True when the file could not be opened; shows a placeholder instead of
  /// an endless spinner.
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant VideoPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A retake can reuse this widget with a new file.
    if (oldWidget.path != widget.path) {
      _release();
      _load();
    }
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  void _load() {
    final controller = VideoPlayerController.file(File(widget.path));
    videoPlayerController = controller;
    _loadFailed = false;
    controller.addListener(_onControllerChanged);
    controller.initialize().then((_) => _onControllerChanged()).catchError((_) {
      // Ignore failures from a controller that was already replaced.
      if (!mounted || videoPlayerController != controller) return;
      setState(() => _loadFailed = true);
    });
  }

  void _release() {
    final controller = videoPlayerController;
    if (controller == null) return;
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    videoPlayerController = null;
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loadFailed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.videocam_off_outlined,
              size: AppIconSize.lg,
              color: textSecondary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Preview unavailable',
              style: AppText.tag,
            ),
          ],
        ),
      );
    }
    if (videoPlayerController == null ||
        !videoPlayerController!.value.isInitialized) {
      return const Center(child: AppSpinner.small());
    }
    final videoSize = videoPlayerController!.value.size;
    final duration = videoPlayerController!.value.duration;
    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: videoSize.width > 0 ? videoSize.width : 1,
            height: videoSize.height > 0 ? videoSize.height : 1,
            child: VideoPlayer(videoPlayerController!),
          ),
        ),
        Center(
          child: Tooltip(
            message: 'Play video',
            child: Material(
              color: mediaScrim,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return widget.title == null
                          ? VideoDialog(path: widget.path)
                          : VideoDialog(path: widget.path, title: widget.title!);
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 28,
                    color: textWhite,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (duration > Duration.zero)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: _DurationChip(duration: duration),
          ),
      ],
    );
  }
}

/// "0:12" on a dark pill over the video thumbnail.
class _DurationChip extends StatelessWidget {
  final Duration duration;

  const _DurationChip({required this.duration});

  @override
  Widget build(BuildContext context) {
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.iconGap,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: mediaScrim,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        '$minutes:$seconds',
        style: AppText.badgeDense.copyWith(
          color: textWhite,
          fontFeatures: AppText.tabular,
        ),
      ),
    );
  }
}
