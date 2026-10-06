import 'package:flutter/material.dart';

import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import 'status_badge.dart';

/// Badge for an inspection-stage status string from the API: Pass / Fail
/// map to their badges, an empty value means the stage hasn't started, and
/// any other value is shown as-is as pending.
StatusBadge stageStatusBadge(String? value, {bool dense = true}) {
  final text = (value ?? '').trim();
  final lower = text.toLowerCase();
  if (text.isEmpty || lower == 'null') {
    return StatusBadge.neutral(
      label: 'Not started',
      icon: Icons.radio_button_unchecked_rounded,
      dense: dense,
    );
  }
  if (lower == 'pass' || lower == 'fail') {
    return StatusBadge.fromResult(text, dense: dense);
  }
  return StatusBadge.pending(label: text, dense: dense);
}

/// Stacked "Manual  [Pass]" / "Machine  [Not started]" rows. A table keeps
/// labels and badges aligned and gives each badge the full remaining width
/// on narrow phones.
class StageStatusTable extends StatelessWidget {
  /// (label, status value) pairs, top to bottom.
  final List<(String, String?)> stages;

  const StageStatusTable({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (var i = 0; i < stages.length; i++)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 0 : AppSpacing.xs,
                  right: AppSpacing.sm,
                ),
                child: Text(stages[i].$1, maxLines: 1, style: AppText.caption),
              ),
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpacing.xs),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: stageStatusBadge(stages[i].$2),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
