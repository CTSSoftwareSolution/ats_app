import '../../../utilities/new_app_theme/app_motion.dart';
import '../../../widgets/new_app_ui/app_spinner.dart';
import 'package:camera/camera.dart';
import 'package:ats_app/utilities/new_app_theme/app_radius.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  /// True while a shutter action is running; further taps are ignored so a
  /// photo isn't taken twice.
  bool _shutterBusy = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      context.read<FileProvider>().disposeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final provider = Provider.of<FileProvider>(context, listen: false);
    provider.disposeCamera();
    super.dispose();
  }

  String? _capturedPath(FileProvider provider) {
    final index = provider.currentIndex;
    if (index == null || index < 0) return null;
    final media = provider.getMedia(index);
    return provider.isVideo ? media?.video?.path : media?.image?.path;
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    final cameraController = fileProvider.controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Scaffold(
        backgroundColor: mediaBg,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppSpinner.large(color: textWhite),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      "Starting camera…",
                      style: AppText.bodySecondary.copyWith(
                        color: textWhiteSub,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.lg,
                child: _CameraRoundButton(
                  tooltip: 'Close camera',
                  icon: Icons.close_rounded,
                  onTap: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final size = MediaQuery.of(context).size;
    final scale = size.aspectRatio * cameraController.value.aspectRatio;
    final padding = MediaQuery.of(context).padding;
    final isRecording = fileProvider.isVideo && fileProvider.isRecording;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (fileProvider.isVideo && fileProvider.isRecording) {
          await fileProvider.stopVideoRecording(save: false);
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: mediaBg,
        body: Stack(
          children: [
            Transform.scale(
              scale: scale < 1 ? 1 / scale : scale,
              child: Center(child: CameraPreview(cameraController)),
            ),
            // Close
            Positioned(
              top: padding.top + 12,
              left: 16,
              child: _CameraRoundButton(
                tooltip: 'Close camera',
                icon: Icons.close_rounded,
                onTap: () async {
                  if (fileProvider.isVideo && fileProvider.isRecording) {
                    await fileProvider.stopVideoRecording(save: false);
                  }
                  if (!context.mounted) return;
                  context.pop();
                },
              ),
            ),
            // Mode label, replaced by the timer while recording
            Positioned(
              top: padding.top + 20,
              left: 72,
              right: 72,
              child: Center(
                child: isRecording
                    ? _CameraPill(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedOpacity(
                              opacity: fileProvider.showBlink ? 1.0 : 0.2,
                              duration: AppMotion.fast,
                              child: const Icon(
                                Icons.circle,
                                color: fail,
                                size: 10,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.iconGap),
                            Text(
                              formatDuration(fileProvider.recordingSeconds),
                              style: AppText.label.copyWith(
                                color: textWhite,
                                height: 1.2,
                                fontFeatures: AppText.tabular,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _CameraPill(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              fileProvider.isVideo
                                  ? Icons.videocam_rounded
                                  : Icons.photo_camera_rounded,
                              color: textWhite,
                              size: 14,
                            ),
                            const SizedBox(width: AppSpacing.iconGap),
                            Text(
                              fileProvider.isVideo ? "Video" : "Photo",
                              style: AppText.chip.copyWith(color: textWhite),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            // Hint + shutter
            Positioned(
              bottom: padding.bottom + 32,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CameraPill(
                    child: Text(
                      fileProvider.isVideo
                          ? (isRecording
                                ? "Tap to stop recording"
                                : "Tap to start recording")
                          : "Tap to capture photo",
                      style: AppText.caption.copyWith(color: textWhite),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Semantics(
                    button: true,
                    label: fileProvider.isVideo
                        ? (isRecording ? 'Stop recording' : 'Start recording')
                        : 'Capture photo',
                    child: GestureDetector(
                      onTap: () async {
                        if (_shutterBusy) return;
                        setState(() => _shutterBusy = true);
                        try {
                          // Return the newly captured file path to the caller so it
                          // can upload it. Returns null if capture failed.
                          final before = _capturedPath(fileProvider);
                          if (fileProvider.isVideo) {
                            if (fileProvider.isRecording) {
                              await fileProvider.stopVideoRecording();
                              if (!context.mounted) return;
                              final after = _capturedPath(fileProvider);
                              debugPrint(
                                "[MEDIA] CameraScreen returning video: $after",
                              );
                              context.pop(after != before ? after : null);
                            } else {
                              await fileProvider.startVideoRecording();
                            }
                          } else {
                            await fileProvider.takePicture(context);
                            if (!context.mounted) return;
                            final after = _capturedPath(fileProvider);
                            debugPrint(
                              "[MEDIA] CameraScreen returning image: $after",
                            );
                            context.pop(after != before ? after : null);
                          }
                        } finally {
                          if (mounted) setState(() => _shutterBusy = false);
                        }
                      },
                      child: AnimatedOpacity(
                        opacity: _shutterBusy ? 0.5 : 1.0,
                        duration: AppMotion.fast,
                        child: _ShutterButton(
                          isVideo: fileProvider.isVideo,
                          isRecording: isRecording,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 48dp translucent round control laid over the camera preview.
class _CameraRoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _CameraRoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: mediaScrim,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: textWhite, size: 22),
          ),
        ),
      ),
    );
  }
}

/// Small translucent pill used for the mode label, timer and hint.
class _CameraPill extends StatelessWidget {
  final Widget child;

  const _CameraPill({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: mediaScrim,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: child,
    );
  }
}

/// White ring shutter: solid white for photo, red dot for video and a red
/// rounded square while recording.
class _ShutterButton extends StatelessWidget {
  final bool isVideo;
  final bool isRecording;

  const _ShutterButton({required this.isVideo, required this.isRecording});

  @override
  Widget build(BuildContext context) {
    final double inner = isRecording ? 28 : 58;
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: textWhite, width: 4),
      ),
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: AppMotion.standard,
        width: inner,
        height: inner,
        decoration: BoxDecoration(
          color: isVideo ? fail : textWhite,
          borderRadius: BorderRadius.circular(isRecording ? 6 : inner / 2),
        ),
      ),
    );
  }
}
