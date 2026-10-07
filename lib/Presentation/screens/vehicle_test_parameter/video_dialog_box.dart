import '../../../utilities/new_app_theme/app_motion.dart';
import '../../../widgets/new_app_ui/app_spinner.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/media_preview_header.dart';

class VideoDialog extends StatefulWidget {
  final String path;

  /// Header text, e.g. "Front bumper · Video".
  final String title;

  const VideoDialog({
    super.key,
    required this.path,
    this.title = 'Video preview',
  });

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog>
    with TickerProviderStateMixin {
  late VideoPlayerController controller;
  bool isInitialized = false;

  /// True when the file could not be opened.
  bool _loadFailed = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: AppMotion.standard,
      value: 1.0,
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    controller = VideoPlayerController.file(File(widget.path));
    controller
        .initialize()
        .then((_) {
          // The dialog may already be closed (and the controller disposed).
          if (!mounted) return;
          setState(() => isInitialized = true);
          controller.play();
          _scheduleHideControls();
        })
        .catchError((_) {
          if (!mounted) return;
          setState(() => _loadFailed = true);
        });

    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _scheduleHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && controller.value.isPlaying) {
        _fadeController.reverse();
      }
    });
  }

  void _onTapVideo() {
    _fadeController.forward();
    _scheduleHideControls();
  }

  void togglePlayPause() {
    if (controller.value.isPlaying) {
      controller.pause();
      _fadeController.forward();
    } else {
      controller.play();
      _scheduleHideControls();
    }
    setState(() {});
  }

  void _seekTo(double value) {
    final duration = controller.value.duration;
    controller.seekTo(
      Duration(milliseconds: (value * duration.inMilliseconds).round()),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// True when the video itself is portrait (aspectRatio < 1)
  bool get _isVideoPortrait {
    if (!isInitialized) return true;

    return controller.value.aspectRatio < 1.0;
  }

  @override
  void dispose() {
    controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDeviceLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Portrait video  → narrower card so it doesn't look stretched
    // Landscape video → wider card to use available screen real estate
    final double dialogWidth = _isVideoPortrait
        ? (isDeviceLandscape ? size.width * 0.52 : size.width * 0.86)
        : (isDeviceLandscape ? size.width * 0.86 : size.width * 0.94);

    return Dialog(
      backgroundColor: mediaBg,
      insetPadding: const EdgeInsets.all(AppSpacing.page),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height * 0.88),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MediaPreviewHeader(
                title: widget.title,
                onClose: () => Navigator.pop(context),
              ),
              if (isInitialized) ...[
                Flexible(child: _buildVideo()),
                _buildControls(context),
              ] else if (_loadFailed)
                SizedBox(
                  height: 220,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.videocam_off_outlined,
                          color: textWhiteSub,
                          size: 32,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "This video can't be played",
                          style: AppText.bodySecondary.copyWith(
                            color: textWhiteSub,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox(
                  height: 220,
                  child: Center(
                    child: AppSpinner.large(color: textWhite),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    return GestureDetector(
      onTap: _onTapVideo,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          FadeTransition(
            opacity: _fadeAnim,
            child: Material(
              color: mediaScrim,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: togglePlayPause,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Icon(
                    controller.value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: textWhite,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    final position = controller.value.position;
    final duration = controller.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;
    final timeStyle = AppText.caption.copyWith(
      color: textWhiteSub,
      fontFeatures: AppText.tabular,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: controller.value.isPlaying ? 'Pause' : 'Play',
            onPressed: togglePlayPause,
            icon: Icon(
              controller.value.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: textWhite,
            ),
          ),
          Text(_formatDuration(position), style: timeStyle),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: textWhite,
                inactiveTrackColor: textWhite.withValues(alpha: 0.2),
                thumbColor: textWhite,
                overlayColor: textWhite.withValues(alpha: 0.12),
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: _seekTo,
              ),
            ),
          ),
          Text(_formatDuration(duration), style: timeStyle),
          IconButton(
            tooltip: 'Replay',
            onPressed: () => controller.seekTo(Duration.zero),
            icon: const Icon(
              Icons.replay_rounded,
              color: textWhiteSub,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
