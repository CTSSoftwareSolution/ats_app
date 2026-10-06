import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../VehicleFilterChip.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_bottom_sheet.dart';
import '../../../widgets/new_app_ui/app_state_view.dart';
import 'capture_status.dart';
import 'image_dialog_box.dart';
import 'media_upload_tracker.dart';
import 'vehicle_parts_responsive_item.dart';
import 'video_dialog_box.dart';

/// Opens the upload queue for the vehicle parts screen: every captured
/// photo/video across all steps with its capture + upload status, progress
/// and a retry for failed items.
///
/// [screenContext] is the parts screen's context (kept alive while the sheet
/// is open and after it closes) and is what retries run with.
void showUploadQueueSheet({
  required BuildContext screenContext,
  required List<dynamic> parts,
  required MediaUploadTracker tracker,
}) {
  showModalBottomSheet(
    context: screenContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _UploadQueueSheet(
      screenContext: screenContext,
      parts: parts,
      tracker: tracker,
    ),
  );
}

/// One captured slot in the queue.
class _QueueItem {
  final int index;
  final bool isVideo;
  final String partName;
  final String path;
  final CaptureStatus status;

  const _QueueItem({
    required this.index,
    required this.isVideo,
    required this.partName,
    required this.path,
    required this.status,
  });
}

enum _QueueFilter { all, failed, uploading, uploaded }

class _UploadQueueSheet extends StatefulWidget {
  final BuildContext screenContext;
  final List<dynamic> parts;
  final MediaUploadTracker tracker;

  const _UploadQueueSheet({
    required this.screenContext,
    required this.parts,
    required this.tracker,
  });

  @override
  State<_UploadQueueSheet> createState() => _UploadQueueSheetState();
}

class _UploadQueueSheetState extends State<_UploadQueueSheet> {
  _QueueFilter _filter = _QueueFilter.all;

  /// Captured slots, newest-problem first: failed, uploading, captured but
  /// not sent, uploaded.
  List<_QueueItem> _items(FileProvider files) {
    final items = <_QueueItem>[];
    for (var i = 0; i < widget.parts.length; i++) {
      final part = widget.parts[i];
      final media = files.getMedia(i);
      for (final isVideo in VehiclePartsResponsiveItem.requiredSlots(part)) {
        final file = isVideo ? media?.video : media?.image;
        if (file == null) continue;
        final name = part.vehiclePartName?.toString().trim() ?? '';
        items.add(_QueueItem(
          index: i,
          isVideo: isVideo,
          partName: name.isEmpty || name == 'null' ? 'Part ${i + 1}' : name,
          // Retry re-sends the file that was last sent for the slot.
          path: widget.tracker.pathOf(i, isVideo) ?? file.path,
          status: CaptureStatus.ofSlot(
            hasFile: true,
            upload: widget.tracker.stateOf(i, isVideo),
          ),
        ));
      }
    }
    const order = {
      CaptureStatus.failed: 0,
      CaptureStatus.uploading: 1,
      CaptureStatus.captured: 2,
      CaptureStatus.uploaded: 3,
      CaptureStatus.notCaptured: 4,
    };
    items.sort((a, b) {
      final byStatus = order[a.status]!.compareTo(order[b.status]!);
      return byStatus != 0 ? byStatus : a.index.compareTo(b.index);
    });
    return items;
  }

  bool _matches(_QueueItem item) {
    switch (_filter) {
      case _QueueFilter.all:
        return true;
      case _QueueFilter.failed:
        return item.status == CaptureStatus.failed;
      case _QueueFilter.uploading:
        return item.status == CaptureStatus.uploading;
      case _QueueFilter.uploaded:
        return item.status == CaptureStatus.uploaded;
    }
  }

  void _retry(_QueueItem item) {
    final screen = widget.screenContext;
    if (!screen.mounted) return;
    VehiclePartsResponsiveItem.uploadMedia(
      context: screen,
      item: widget.parts[item.index],
      allIndex: item.index,
      tracker: widget.tracker,
      filePath: item.path,
      isVideo: item.isVideo,
    );
  }

  /// Retries failed items one after another (not all at once).
  Future<void> _retryAll(List<_QueueItem> failed) async {
    for (final item in failed) {
      final screen = widget.screenContext;
      if (!screen.mounted) return;
      await VehiclePartsResponsiveItem.uploadMedia(
        context: screen,
        item: widget.parts[item.index],
        allIndex: item.index,
        tracker: widget.tracker,
        filePath: item.path,
        isVideo: item.isVideo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final files = context.watch<FileProvider>();
    return ListenableBuilder(
      listenable: widget.tracker,
      builder: (context, _) {
        final items = _items(files);
        final count = <CaptureStatus, int>{};
        for (final i in items) {
          count[i.status] = (count[i.status] ?? 0) + 1;
        }
        final uploaded = count[CaptureStatus.uploaded] ?? 0;
        final uploading = count[CaptureStatus.uploading] ?? 0;
        final failedItems =
            items.where((i) => i.status == CaptureStatus.failed).toList();
        final visible = items.where(_matches).toList();

        return AppBottomSheet(
          title: 'Uploads',
          subtitle: items.isEmpty
              ? 'Captured photos and videos appear here'
              : '$uploaded of ${items.length} uploaded'
                  '${uploading > 0 ? ' · $uploading in progress' : ''}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (items.isNotEmpty) ...[
                // Overall progress (by item count; the upload request does
                // not report byte progress).
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: uploaded / items.length,
                    minHeight: 6,
                    backgroundColor: surface2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        uploaded == items.length ? pass : appColor),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final f in _QueueFilter.values)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: VehicleFilterChip(
                            label: switch (f) {
                              _QueueFilter.all => 'All ${items.length}',
                              _QueueFilter.failed => 'Failed ${failedItems.length}',
                              _QueueFilter.uploading => 'Uploading $uploading',
                              _QueueFilter.uploaded => 'Uploaded $uploaded',
                            },
                            isSelected: _filter == f,
                            onTap: () => setState(() => _filter = f),
                          ),
                        ),
                    ],
                  ),
                ),
                if (failedItems.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _FailedBanner(
                    count: failedItems.length,
                    onRetryAll: () => _retryAll(failedItems),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
              ],
              if (items.isEmpty)
                const AppStateView.empty(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Nothing captured yet',
                  message: 'Each photo or video starts uploading as soon as you capture it.',
                )
              else if (visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: Text(
                    _filter == _QueueFilter.failed
                        ? 'No failed uploads.'
                        : 'No items in this view.',
                    textAlign: TextAlign.center,
                    style: AppText.bodySecondary,
                  ),
                )
              else
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: border),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < visible.length; i++) ...[
                        if (i > 0) const Divider(height: 1, indent: 76),
                        _QueueRow(
                          item: visible[i],
                          totalParts: widget.parts.length,
                          onRetry: () => _retry(visible[i]),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FailedBanner extends StatelessWidget {
  final int count;
  final VoidCallback onRetryAll;

  const _FailedBanner({required this.count, required this.onRetryAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.xs, AppSpacing.xs),
      decoration: BoxDecoration(
        color: failLight,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: AppIconSize.md, color: fail),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              count == 1 ? '1 upload failed' : '$count uploads failed',
              style: AppText.chip.copyWith(color: fail),
            ),
          ),
          TextButton.icon(
            onPressed: onRetryAll,
            style: TextButton.styleFrom(foregroundColor: fail),
            icon: const Icon(Icons.refresh_rounded, size: AppIconSize.md),
            label: Text(count == 1 ? 'Retry' : 'Retry all'),
          ),
        ],
      ),
    );
  }
}

/// Compact row: thumbnail · part + media type · status (+ progress) · action.
class _QueueRow extends StatelessWidget {
  final _QueueItem item;
  final int totalParts;
  final VoidCallback onRetry;

  const _QueueRow({required this.item, required this.totalParts, required this.onRetry});

  void _preview(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => item.isVideo
          ? VideoDialog(path: item.path)
          : ImageDialogBox(path: item.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = item.status;
    final kind = item.isVideo ? 'Video' : 'Photo';

    final Widget trailing;
    switch (status) {
      case CaptureStatus.failed:
        trailing = OutlinedButton.icon(
          onPressed: onRetry,
          style: OutlinedButton.styleFrom(
            foregroundColor: fail,
            side: BorderSide(color: fail.withValues(alpha: 0.5)),
            minimumSize: const Size(0, 40),
            tapTargetSize: MaterialTapTargetSize.padded,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            textStyle: AppText.button.copyWith(fontSize: 14),
          ),
          icon: const Icon(Icons.refresh_rounded, size: AppIconSize.sm + 2),
          label: const Text('Retry'),
        );
      case CaptureStatus.uploaded:
        trailing = const SizedBox(
          width: 48,
          height: 48,
          child: Icon(Icons.check_circle_rounded, color: pass, size: AppIconSize.lg),
        );
      // Uploading is shown by the badge + progress bar in the row itself.
      case CaptureStatus.uploading:
      case CaptureStatus.captured:
      case CaptureStatus.notCaptured:
        trailing = const SizedBox(width: 48, height: 48);
    }

    return Semantics(
      container: true,
      label: '${item.partName}, $kind, ${status.label}',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
        child: Row(
          children: [
            _Thumbnail(item: item, onTap: () => _preview(context)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.partName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Part ${item.index + 1} of $totalParts · $kind',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(alignment: Alignment.centerLeft, child: status.badge()),
                  if (status == CaptureStatus.uploading) ...[
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: const LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: surface2,
                        color: accent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// 52dp preview tile. Photos show the image; videos show a play tile
/// (no video player per row, to keep the list light). Tap to preview.
class _Thumbnail extends StatelessWidget {
  final _QueueItem item;
  final VoidCallback onTap;

  const _Thumbnail({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final failed = item.status == CaptureStatus.failed;
    return Tooltip(
      message: 'Preview ${item.isVideo ? 'video' : 'photo'}',
      child: Material(
        color: item.isVideo ? textPrimary : surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          side: failed ? const BorderSide(color: fail, width: 1.5) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: item.isVideo
                ? const Icon(Icons.play_circle_outline_rounded,
                    color: textWhite, size: AppIconSize.lg + 4)
                : Image.file(
                    File(item.path),
                    fit: BoxFit.cover,
                    cacheWidth: 156,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined, color: na, size: AppIconSize.md),
                  ),
          ),
        ),
      ),
    );
  }
}
