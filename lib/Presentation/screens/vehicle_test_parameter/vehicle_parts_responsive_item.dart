import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/status_badge.dart';
import '../../provider/create_queue_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../camera_page/camera_screen.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/media_upload_tracker.dart';

class VehiclePartsResponsiveItem extends StatelessWidget {
  final dynamic item;
  final int allIndex;
  final bool isTablet;
  final MediaUploadTracker tracker;
  const VehiclePartsResponsiveItem({
    super.key,
    required this.item,
    required this.allIndex,
    required this.isTablet,
    required this.tracker,
  });

  /// Sends a captured file to the upload queue and records the slot's
  /// upload state for the UI.
  Future<void> _uploadMedia(
    BuildContext context,
    String filePath,
    bool isVideo,
  ) async {
    try {
      final classProvider = context.read<VehicleClassProvider>();

      final queueProvider = context.read<CreateQueueProvider>();

      final registrationNo = classProvider.selectedClass!.registrationNo
          .toString();
      final applicationNo = classProvider.selectedClass!.bookingId.toString();
      final questionId = item.questionId.toString();
      final inspectionId = item.id.toString();
      final imagePath = isVideo ? null : filePath;
      final videoPath = isVideo ? filePath : null;

      debugPrint("[MEDIA] Calling uploadMedia");
      debugPrint("[MEDIA] registrationNo: $registrationNo");
      debugPrint("[MEDIA] applicationNo: $applicationNo");
      debugPrint("[MEDIA] questionId: $questionId");
      debugPrint("[MEDIA] inspectionId: $inspectionId");
      debugPrint("[MEDIA] imagePath: $imagePath");
      debugPrint("[MEDIA] videoPath: $videoPath");

      tracker.set(allIndex, isVideo, SlotUploadState.uploading, path: filePath);

      final queueResult = await queueProvider.uploadMedia(
        registrationNo: registrationNo,
        applicationNo: applicationNo,
        questionId: questionId,
        inspectionId: inspectionId,
        imagePath: imagePath,
        videoPath: videoPath,
      );

      debugPrint(
        "[MEDIA] uploadMedia completed: success=${queueResult?.success}, "
        "error=${queueProvider.errorMessage}",
      );

      tracker.set(
        allIndex,
        isVideo,
        queueResult?.success == true
            ? SlotUploadState.uploaded
            : SlotUploadState.failed,
      );

      if (queueResult?.success != true && context.mounted) {
        CustomLoader.message(
          queueProvider.errorMessage ?? 'Media upload failed',
        );
      }
    } catch (e, st) {
      tracker.set(allIndex, isVideo, SlotUploadState.failed);
      debugPrint("[MEDIA] Exception before/while calling uploadMedia: $e\n$st");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildImageContainer({required bool isVideo}) {
      final retryPath = tracker.pathOf(allIndex, isVideo);
      return Expanded(
        child: UploadImageContainer(
          isVideo: isVideo,
          width: 180,
          index: allIndex,
          image: isVideo ? videoUploadImage : pictureUploadImage,
          imageHeight: 25.0,
          imageWidth: 25.0,
          text: isVideo ? "Capture video" : "Capture photo",
          uploadState: tracker.stateOf(allIndex, isVideo),
          onRetry: retryPath == null
              ? null
              : () => _uploadMedia(context, retryPath, isVideo),
          onTap: () async {
            debugPrint(
              "[MEDIA] onTap triggered (index: $allIndex, isVideo: $isVideo)",
            );
            final fileProvider = context.read<FileProvider>();

            fileProvider.setCurrentIndex(allIndex);
            fileProvider.setVideo(isVideo);

            debugPrint("[MEDIA] Opening CameraScreen");
            final result = await context.push(CameraScreen());
            debugPrint("[MEDIA] Camera result: $result");

            if (result == null) {
              debugPrint("[MEDIA] Early return: result is null");
              return;
            }

            final filePath = result.toString();
            debugPrint("[MEDIA] File path: $filePath");

            if (filePath.isEmpty) {
              debugPrint("[MEDIA] Early return: filePath is empty");
              return;
            }

            if (!context.mounted) {
              debugPrint("[MEDIA] Early return: context not mounted");
              return;
            }

            await _uploadMedia(context, filePath, isVideo);
          },
          isTablet: isTablet,
        ),
      );
    }

    final media = context.watch<FileProvider>().getMedia(allIndex);
    final captured = isCaptured(item, media);
    final partName = item.vehiclePartName.toString();
    final String requirement = item.type == 1
        ? "Photo required"
        : item.type == 2
        ? "Video required"
        : "Photo and video required";

    return ListenableBuilder(
      listenable: tracker,
      builder: (context, _) {
        final failed = _slotStates().contains(SlotUploadState.failed);
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          borderColor: failed
              ? fail.withValues(alpha: 0.45)
              : captured
              ? pass.withValues(alpha: 0.35)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sectionTitle,
                        ),
                        const SizedBox(height: 2),
                        Text(requirement, style: AppText.caption),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _statusBadge(captured),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (item.type == 1) ...[
                    buildImageContainer(isVideo: false),
                  ] else if (item.type == 2) ...[
                    buildImageContainer(isVideo: true),
                  ] else ...[
                    buildImageContainer(isVideo: false),
                    const SizedBox(width: AppSpacing.md),
                    buildImageContainer(isVideo: true),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Upload states of the slots this part requires.
  List<SlotUploadState?> _slotStates() {
    final slots = switch (item.type) {
      1 => const [false],
      2 => const [true],
      _ => const [false, true],
    };
    return slots.map((isVideo) => tracker.stateOf(allIndex, isVideo)).toList();
  }

  /// Part-level status: a failed upload first, then uploading, then
  /// uploaded/captured, otherwise still required.
  Widget _statusBadge(bool captured) {
    final states = _slotStates();
    if (states.contains(SlotUploadState.failed)) {
      return const StatusBadge.error(label: 'Upload failed', dense: true);
    }
    if (states.contains(SlotUploadState.uploading)) {
      return const StatusBadge.uploading(dense: true);
    }
    if (!captured)
      return const StatusBadge.pending(label: 'Required', dense: true);
    if (states.every((s) => s == SlotUploadState.uploaded)) {
      return const StatusBadge.uploaded(dense: true);
    }
    return const StatusBadge.captured(dense: true);
  }

  /// Whether every media type required by [item] has been captured.
  /// Mirrors the rule used by `VehiclePartsProvider.validateMedia`.
  static bool isCaptured(dynamic item, MediaFile? media) {
    switch (item.type) {
      case 1:
        return media?.image != null;
      case 2:
        return media?.video != null;
      default:
        return media?.image != null && media?.video != null;
    }
  }
}
