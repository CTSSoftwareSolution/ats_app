import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/new_app_ui/stage_status.dart';
import '../../../../widgets/new_app_ui/status_badge.dart';

/// Where an appointment is in the inspection workflow.
enum InspectionPhase { pending, inProgress, completed }

/// One inspection stage of an appointment and its raw API status.
class InspectionStage {
  final String label;
  final String? rawStatus;

  const InspectionStage(this.label, this.rawStatus);

  String get _value {
    final text = (rawStatus ?? '').trim();
    return text.toLowerCase() == 'null' ? '' : text;
  }

  /// Any status at all: the stage has been started.
  bool get isStarted => _value.isNotEmpty;

  /// A final result: Pass or Fail.
  bool get isFinished {
    final lower = _value.toLowerCase();
    return lower == 'pass' || lower == 'fail';
  }

  bool get isFailed => _value.toLowerCase() == 'fail';

  /// Pass / Fail / the API's own pending text / "Not started".
  StatusBadge badge() => stageStatusBadge(rawStatus);
}

/// Read-only summary of an appointment's two inspection stages, derived from
/// the statuses the list API already returns. Display logic only: nothing
/// here is sent back to the server.
class AppointmentStatus {
  final List<InspectionStage> stages;

  AppointmentStatus(Appointments item)
    : stages = [
        InspectionStage('Manual', item.manualPreInspectionStatus),
        // Machine inspection is the media capture flow that ends on the AI
        // result screen.
        InspectionStage('AI', item.machineInspectonStatus),
      ];

  int get finishedCount => stages.where((s) => s.isFinished).length;
  int get total => stages.length;
  double get progress => total == 0 ? 0 : finishedCount / total;
  bool get hasFailure => stages.any((s) => s.isFailed);

  InspectionPhase get phase {
    if (finishedCount == total) return InspectionPhase.completed;
    if (stages.any((s) => s.isStarted)) return InspectionPhase.inProgress;
    return InspectionPhase.pending;
  }

  /// Overall badge: Pending, In progress, Completed – or Failed when every
  /// stage is done and at least one failed.
  StatusBadge badge({bool dense = true}) {
    switch (phase) {
      case InspectionPhase.pending:
        return StatusBadge.pending(dense: dense);
      case InspectionPhase.inProgress:
        return StatusBadge.inProgress(dense: dense);
      case InspectionPhase.completed:
        return hasFailure
            ? StatusBadge.fail(label: 'Failed', dense: dense)
            : StatusBadge.completed(dense: dense);
    }
  }

  /// Verb for the card's action. Every label opens the same inspection flow.
  String get actionLabel => switch (phase) {
    InspectionPhase.pending => 'Start',
    InspectionPhase.inProgress => 'Continue',
    InspectionPhase.completed => 'Open',
  };

  IconData get actionIcon => switch (phase) {
    InspectionPhase.pending => Icons.play_arrow_rounded,
    InspectionPhase.inProgress => Icons.arrow_forward_rounded,
    InspectionPhase.completed => Icons.arrow_forward_rounded,
  };

  /// "1 of 2 stages done" for the progress row and screen readers.
  String get progressLabel => '$finishedCount of $total stages done';
}
