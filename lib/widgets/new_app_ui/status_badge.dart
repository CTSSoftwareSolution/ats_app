import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Stadium-shaped status pill: tinted background, hairline border, icon and
/// text, so status never relies on colour alone. Use the named
/// constructors so a given status always looks the same.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;
  final bool dense;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.icon,
    this.dense = false,
  });

  const StatusBadge.pass({super.key, this.label = 'Pass', this.dense = false})
    : color = pass,
      background = passLight,
      icon = Icons.check_circle_rounded;

  const StatusBadge.fail({super.key, this.label = 'Fail', this.dense = false})
    : color = fail,
      background = failLight,
      icon = Icons.cancel_rounded;

  const StatusBadge.pending({
    super.key,
    this.label = 'Pending',
    this.dense = false,
  }) : color = warn,
       background = warnLight,
       icon = Icons.schedule_rounded;

  /// Work has started but isn't finished (e.g. one of two stages done).
  const StatusBadge.inProgress({
    super.key,
    this.label = 'In progress',
    this.dense = false,
  }) : color = infoColor,
       background = infoLight,
       icon = Icons.timelapse_rounded;

  /// Every step is finished and nothing failed.
  const StatusBadge.completed({
    super.key,
    this.label = 'Completed',
    this.dense = false,
  }) : color = pass,
       background = passLight,
       icon = Icons.task_alt_rounded;

  const StatusBadge.neutral({
    super.key,
    required this.label,
    this.icon,
    this.dense = false,
  }) : color = na,
       background = naLight;

  /// Media is on the device but not yet sent.
  const StatusBadge.captured({
    super.key,
    this.label = 'Captured',
    this.dense = false,
  }) : color = appColor,
       background = accentLight,
       icon = Icons.photo_camera_rounded;

  const StatusBadge.uploading({
    super.key,
    this.label = 'Uploading',
    this.dense = false,
  }) : color = infoColor,
       background = infoLight,
       icon = Icons.cloud_upload_rounded;

  const StatusBadge.uploaded({
    super.key,
    this.label = 'Uploaded',
    this.dense = false,
  }) : color = pass,
       background = passLight,
       icon = Icons.cloud_done_rounded;

  const StatusBadge.processing({
    super.key,
    this.label = 'Processing',
    this.dense = false,
  }) : color = infoColor,
       background = infoLight,
       icon = Icons.hourglass_top_rounded;

  const StatusBadge.error({super.key, this.label = 'Error', this.dense = false})
    : color = fail,
      background = failLight,
      icon = Icons.error_rounded;

  /// Maps a Pass/Fail string coming from the API to the matching badge.
  factory StatusBadge.fromResult(String? result, {bool dense = false}) {
    final value = (result ?? '').trim().toLowerCase();
    if (value == 'pass') {
      return StatusBadge.pass(label: result!.trim(), dense: dense);
    }
    if (value == 'fail') {
      return StatusBadge.fail(label: result!.trim(), dense: dense);
    }
    return StatusBadge.pending(
      label: value.isEmpty ? 'Pending' : result!.trim(),
      dense: dense,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? AppSpacing.sm : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: dense ? AppIconSize.xxs : AppIconSize.xs,
              color: color,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (dense ? AppText.badgeDense : AppText.badge).copyWith(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
