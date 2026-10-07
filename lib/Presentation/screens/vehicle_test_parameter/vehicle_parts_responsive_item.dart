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
import '../../../utilities/new_app_theme/app_icon_size.dart';
import 'capture_status.dart';
import '../../provider/create_queue_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../camera_page/camera_screen.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/media_upload_tracker.dart';

class VehiclePartsResponsiveItem extends StatelessWidget {
  final dynamic item;
  final int allIndex;
  final bool isTablet;
  final MediaUploadTracker tracker;

  /// Total number of parts across all steps (for "Part 3 of 12").
  final int totalParts;

  /// The first part on the step still missing media; outlined and tagged
  /// "Up next" so the inspector sees where to continue.
  final bool isUpNext;

  const VehiclePartsResponsiveItem({
    super.key,
    required this.item,
    required this.allIndex,
    required this.isTablet,
    required this.tracker,
    this.totalParts = 0,
    this.isUpNext = false,
  });

  /// Sends a captured file to the upload queue and records the slot's
  /// upload state for the UI.
  Future<void> _uploadMedia(
    BuildContext context,
    String filePath,
    bool isVideo,
  ) => uploadMedia(
    context: context,
    item: item,
    allIndex: allIndex,
    tracker: tracker,
    filePath: filePath,
    isVideo: isVideo,
  );

  /// The one upload path for a capture slot, shared by the part card and the
  /// uploads sheet (retry). Calls [CreateQueueProvider.uploadMedia] and
  /// records the slot's state in [tracker].
  static Future<void> uploadMedia({
    required BuildContext context,
    required dynamic item,
    required int allIndex,
    required MediaUploadTracker tracker,
    required String filePath,
    required bool isVideo,
  }) async {
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
    final partName = _text(item.vehiclePartName);
    final partLabel = partName.isEmpty ? 'Vehicle part' : partName;

    Widget buildImageContainer({required bool isVideo}) {
      final retryPath = tracker.pathOf(allIndex, isVideo);
      return Expanded(
        child: UploadImageContainer(
          isVideo: isVideo,
          previewTitle: '$partLabel · ${isVideo ? 'Video' : 'Photo'}',
          width: double.infinity,
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

    // Media slots this part requires (false = photo, true = video).
    final slots = requiredSlots(item);

    /// A labelled slot: "PHOTO · REQUIRED" / "VIDEO" above the capture area.
    /// Once captured, the thumbnail carries the slot's status badge.
    Widget slot(bool isVideo) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isVideo ? Icons.videocam_outlined : Icons.photo_camera_outlined,
                size: AppIconSize.sm,
                color: na,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(isVideo ? 'VIDEO' : 'PHOTO', style: AppText.overline),
              if ((isVideo ? media?.video : media?.image) == null)
                Flexible(
                  child: Text(
                    ' · REQUIRED',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.overline.copyWith(color: warn),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(children: [buildImageContainer(isVideo: isVideo)]),
        ],
      ),
    );

    return ListenableBuilder(
      listenable: tracker,
      builder: (context, _) {
        final status = partStatus(item, media, tracker, allIndex);
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.card),
          borderColor: status == CaptureStatus.failed
              ? fail.withValues(alpha: 0.45)
              : status == CaptureStatus.uploaded
              ? pass.withValues(alpha: 0.35)
              : isUpNext
              ? appColor.withValues(alpha: 0.45)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Part number + status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      totalParts > 0
                          ? 'PART ${allIndex + 1} OF $totalParts'
                          : 'PART ${allIndex + 1}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.overline,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Capped rather than Flexible so the badge sits flush right.
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    // "Up next" stands in for "Required"; uploading and
                    // failed states still show their own badge.
                    child: isUpNext && status == CaptureStatus.notCaptured
                        ? const _UpNextTag()
                        : status.badge(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                partLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                switch (slots.length) {
                  1 => slots.first ? 'Record a video' : 'Take a photo',
                  _ => 'Take a photo and record a video',
                },
                style: AppText.caption,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < slots.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.md),
                    slot(slots[i]),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  /// Slots required by [item]: type 1 = photo, 2 = video, otherwise both.
  /// (false = photo, true = video.)
  static List<bool> requiredSlots(dynamic item) => switch (item.type) {
    1 => const [false],
    2 => const [true],
    _ => const [false, true],
  };

  /// Combined [CaptureStatus] of all slots of [item].
  static CaptureStatus partStatus(
    dynamic item,
    MediaFile? media,
    MediaUploadTracker tracker,
    int index,
  ) {
    return CaptureStatus.combine([
      for (final isVideo in requiredSlots(item))
        CaptureStatus.ofSlot(
          hasFile: isVideo ? media?.video != null : media?.image != null,
          upload: tracker.stateOf(index, isVideo),
        ),
    ]);
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

/// Brand badge marking the part the inspector should do next (it is still
/// required, so it replaces the "Required" badge).
class _UpNextTag extends StatelessWidget {
  const _UpNextTag();

  @override
  Widget build(BuildContext context) {
    return const StatusBadge(
      label: 'Up next',
      color: appColor,
      background: accentLight,
      icon: Icons.arrow_forward_rounded,
      dense: true,
    );
  }
}
