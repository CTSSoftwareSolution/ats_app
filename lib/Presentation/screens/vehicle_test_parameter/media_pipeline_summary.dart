import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_banner.dart';
import '../../../widgets/new_app_ui/app_segmented_bar.dart';
import 'capture_status.dart';

/// Where every required photo / video of this inspection stands, at a glance:
///
///   12 of 18 uploaded                         View uploads ›
///   ▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱▱   (uploaded · uploading · captured · failed · required)
///   ● 12 uploaded  ● 1 uploading  ● 2 failed  ○ 3 required
///   [!] 2 uploads failed …                        Review failed
///
/// Display only: built from the same per-slot [CaptureStatus] the cards use.
class MediaPipelineSummary extends StatelessWidget {
  /// Status of every required slot across all parts.
  final List<CaptureStatus> slots;

  /// Opens the uploads sheet.
  final VoidCallback onViewUploads;

  /// Opens the uploads sheet showing only failed items.
  final VoidCallback onReviewFailed;

  const MediaPipelineSummary({
    super.key,
    required this.slots,
    required this.onViewUploads,
    required this.onReviewFailed,
  });

  /// Bar / legend order: done first, then in flight, then problems, then
  /// what is still to do.
  static const _order = [
    CaptureStatus.uploaded,
    CaptureStatus.uploading,
    CaptureStatus.captured,
    CaptureStatus.failed,
    CaptureStatus.notCaptured,
  ];

  @override
  Widget build(BuildContext context) {
    final count = {for (final s in _order) s: 0};
    for (final s in slots) {
      count[s] = count[s]! + 1;
    }
    final total = slots.length;
    final uploaded = count[CaptureStatus.uploaded]!;
    final failed = count[CaptureStatus.failed]!;
    final nothingCaptured = count[CaptureStatus.notCaptured] == total;
    final allUploaded = total > 0 && uploaded == total;

    final segments = [
      for (final s in _order)
        AppSegment(
          value: count[s]!,
          label: _legendLabel(s),
          color: s.color,
          remaining: s == CaptureStatus.notCaptured,
          emphasize: s == CaptureStatus.failed,
        ),
    ];

    final legend = <String>[
      for (final s in _order)
        if (count[s]! > 0) '${count[s]} ${_legendLabel(s)}',
    ].join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label: 'Media: $uploaded of $total uploaded. $legend. View uploads',
          excludeSemantics: true,
          child: InkWell(
            onTap: onViewUploads,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 32),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: AppIconSize.sm,
                          color: na,
                        ),
                        const SizedBox(width: AppSpacing.iconGap),
                        Expanded(
                          child: Text(
                            '$uploaded of $total media uploaded',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.label.copyWith(
                              fontFeatures: AppText.tabular,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'View uploads',
                          style: AppText.chip.copyWith(color: appColor),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: appColor,
                          size: AppIconSize.md,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppSegmentedBar(segments: segments),
                  const SizedBox(height: AppSpacing.sm),
                  AppSegmentLegend(segments: segments),
                ],
              ),
            ),
          ),
        ),
        if (nothingCaptured) ...[
          const SizedBox(height: AppSpacing.xs),
          const Text(
            "Capture each required photo and video below. Each one uploads as soon as it's captured.",
            style: AppText.caption,
          ),
        ],
        if (failed > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          AppBanner.error(
            title: failed == 1 ? '1 upload failed' : '$failed uploads failed',
            message:
                'Tap Retry on the item marked in red, or review them all at once.',
            actionLabel: 'Review failed',
            onAction: onReviewFailed,
          ),
        ] else if (allUploaded) ...[
          const SizedBox(height: AppSpacing.sm),
          const AppBanner.success(
            message: 'All photos and videos are captured and uploaded.',
          ),
        ],
      ],
    );
  }

  static String _legendLabel(CaptureStatus s) => switch (s) {
    CaptureStatus.uploaded => 'uploaded',
    CaptureStatus.uploading => 'uploading',
    CaptureStatus.captured => 'not sent',
    CaptureStatus.failed => 'failed',
    CaptureStatus.notCaptured => 'required',
  };
}

