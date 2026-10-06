import 'dart:io';

import 'package:ats_app/Presentation/screens/vehicle_test_parameter/video_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../utilities/color_data.dart';

class VideoPreviewWidget extends StatefulWidget {
  final String path;
  const VideoPreviewWidget({super.key, required this.path});

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
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off_outlined, size: 24, color: textSecondary),
            SizedBox(height: 4),
            Text(
              'Preview unavailable',
              style: TextStyle(fontFamily: "SemiBold", fontSize: 12, color: textSecondary),
            ),
          ],
        ),
      );
    }
    if (videoPlayerController == null || !videoPlayerController!.value.isInitialized) {
      return const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: appColor),
        ),
      );
    }
    final videoSize = videoPlayerController!.value.size;
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
              color: Colors.black.withValues(alpha: 0.45),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return VideoDialog(path: widget.path);
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.play_arrow_rounded, size: 28, color: textWhite),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
