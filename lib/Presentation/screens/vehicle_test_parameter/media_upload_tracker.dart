import 'package:flutter/foundation.dart';

/// Upload state of one capture slot, as shown in the UI.
enum SlotUploadState { uploading, uploaded, failed }

/// UI-only record of the queue upload for each capture slot of the vehicle
/// test parameter flow, so a slot can show Uploading / Uploaded / Failed and
/// a failed upload can be retried with the same file.
///
/// Lives for one visit of the vehicle parts screen; it does not touch the
/// upload request itself.
class MediaUploadTracker extends ChangeNotifier {
  final Map<String, SlotUploadState> _states = {};
  final Map<String, String> _paths = {};

  static String _key(int index, bool isVideo) =>
      '$index-${isVideo ? 'v' : 'i'}';

  int get failedCount =>
      _states.values.where((s) => s == SlotUploadState.failed).length;

  SlotUploadState? stateOf(int index, bool isVideo) =>
      _states[_key(index, isVideo)];

  /// Path of the file last sent for this slot (used for retry).
  String? pathOf(int index, bool isVideo) => _paths[_key(index, isVideo)];

  void set(int index, bool isVideo, SlotUploadState state, {String? path}) {
    final key = _key(index, isVideo);
    _states[key] = state;
    if (path != null) _paths[key] = path;
    notifyListeners();
  }
}
