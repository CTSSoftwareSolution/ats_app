import 'package:flutter/material.dart';

import '../../../widgets/new_app_ui/status_badge.dart';
import 'media_upload_tracker.dart';

/// The one status vocabulary for media capture, shown the same way on the
/// slot, the part card and the screen summary:
///
///   Not captured → Captured → Uploading → Uploaded
///                                       ↘ Upload failed (retry)
///
/// Derived purely from what the UI already knows: whether a file exists for
/// the slot and the [SlotUploadState] recorded by [MediaUploadTracker].
enum CaptureStatus {
  notCaptured,
  captured,
  uploading,
  uploaded,
  failed;

  /// Status of one photo/video slot. A slot that is not uploaded on capture
  /// (no tracker state) stays "Captured".
  static CaptureStatus ofSlot({required bool hasFile, SlotUploadState? upload}) {
    if (!hasFile) return CaptureStatus.notCaptured;
    switch (upload) {
      case SlotUploadState.uploading:
        return CaptureStatus.uploading;
      case SlotUploadState.uploaded:
        return CaptureStatus.uploaded;
      case SlotUploadState.failed:
        return CaptureStatus.failed;
      case null:
        return CaptureStatus.captured;
    }
  }

  /// Status of a part that needs several slots: the state that needs the
  /// inspector's attention first wins (failed, then uploading, then anything
  /// still missing), otherwise the least-advanced captured state.
  static CaptureStatus combine(List<CaptureStatus> slots) {
    if (slots.isEmpty) return CaptureStatus.notCaptured;
    if (slots.contains(CaptureStatus.failed)) return CaptureStatus.failed;
    if (slots.contains(CaptureStatus.uploading)) return CaptureStatus.uploading;
    if (slots.contains(CaptureStatus.notCaptured)) return CaptureStatus.notCaptured;
    if (slots.contains(CaptureStatus.captured)) return CaptureStatus.captured;
    return CaptureStatus.uploaded;
  }

  String get label {
    switch (this) {
      case CaptureStatus.notCaptured:
        return 'Not captured';
      case CaptureStatus.captured:
        return 'Captured';
      case CaptureStatus.uploading:
        return 'Uploading';
      case CaptureStatus.uploaded:
        return 'Uploaded';
      case CaptureStatus.failed:
        return 'Upload failed';
    }
  }

  StatusBadge badge({bool dense = true}) {
    switch (this) {
      case CaptureStatus.notCaptured:
        return StatusBadge.neutral(
          label: label,
          icon: Icons.radio_button_unchecked_rounded,
          dense: dense,
        );
      case CaptureStatus.captured:
        return StatusBadge.captured(label: label, dense: dense);
      case CaptureStatus.uploading:
        return StatusBadge.uploading(label: label, dense: dense);
      case CaptureStatus.uploaded:
        return StatusBadge.uploaded(label: label, dense: dense);
      case CaptureStatus.failed:
        return StatusBadge.error(label: label, dense: dense);
    }
  }
}
