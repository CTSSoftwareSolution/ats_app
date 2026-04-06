import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDialog extends StatefulWidget {
  final String path;

  const VideoDialog({super.key, required this.path});

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog>
    with TickerProviderStateMixin {
  late VideoPlayerController controller;
  bool isInitialized = false;
  bool _showControls = true;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;



  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0,
    );
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    controller = VideoPlayerController.file(File(widget.path));
    controller.initialize().then((_) {
      setState(() => isInitialized = true);
      controller.play();
      _scaleController.forward();
      _scheduleHideControls();
    });

    controller.addListener(() => setState(() {}));
  }

  void _scheduleHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && controller.value.isPlaying) {
        _fadeController.reverse();
        setState(() => _showControls = false);
      }
    });
  }

  void _onTapVideo() {
    setState(() => _showControls = true);
    _fadeController.forward();
    _scheduleHideControls();
  }

  void togglePlayPause() {
    if (controller.value.isPlaying) {
      controller.pause();
      _fadeController.forward();
      setState(() => _showControls = true);
    } else {
      controller.play();
      _scheduleHideControls();
    }
    setState(() {});
  }

  void _seekTo(double value) {
    final duration = controller.value.duration;
    controller.seekTo(
        Duration(milliseconds: (value * duration.inMilliseconds).round()));
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
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: isInitialized ? _buildPlayer(context) : _buildLoader(),
    );
  }

  Widget _buildLoader() {
    return const SizedBox(
      height: 220,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    );
  }

  Widget _buildPlayer(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDeviceLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final position = controller.value.position;
    final duration = controller.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    // Portrait video  → narrower card so it doesn't look stretched
    // Landscape video → wider card to use available screen real estate
    final double dialogWidth = _isVideoPortrait
        ? (isDeviceLandscape ? size.width * 0.52 : size.width * 0.80)
        : (isDeviceLandscape ? size.width * 0.86 : size.width * 0.94);

    return ScaleTransition(
      scale: _scaleAnim,
      child: Center(
        child: SizedBox(
          width: dialogWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.09),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.65),
                      blurRadius: 56,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Video area
                    GestureDetector(
                      onTap: _onTapVideo,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Video — AspectRatio drives the height automatically
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            ),
                          ),

                          // Cinematic vignette
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.5),
                                    ],
                                    stops: const [0.0, 0.22, 0.70, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Play / Pause button
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: GestureDetector(
                              onTap: togglePlayPause,
                              child: Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.38),
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  controller.value.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                            ),
                          ),

                          // Orientation badge — top left
                          Positioned(
                            top: 12,
                            left: 12,
                            child: _OrientationBadge(
                                isPortrait: _isVideoPortrait),
                          ),

                          // Close button — top right
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.45),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.22),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Controls bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14),
                              activeTrackColor: Colors.white,
                              inactiveTrackColor:
                              Colors.white.withOpacity(0.18),
                              thumbColor: Colors.white,
                              overlayColor: Colors.white.withOpacity(0.12),
                            ),
                            child: Slider(
                              value: progress.clamp(0.0, 1.0),
                              onChanged: _seekTo,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    controller.seekTo(Duration.zero),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                  child: const Icon(
                                    Icons.replay_rounded,
                                    color: Colors.white60,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Orientation badge widget
class _OrientationBadge extends StatelessWidget {
  final bool isPortrait;

  const _OrientationBadge({required this.isPortrait});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.42),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPortrait
                    ? Icons.stay_current_portrait_rounded
                    : Icons.stay_current_landscape_rounded,
                color: Colors.white70,
                size: 13,
              ),
              const SizedBox(width: 5),
              Text(
                isPortrait ? 'Portrait' : 'Landscape',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
