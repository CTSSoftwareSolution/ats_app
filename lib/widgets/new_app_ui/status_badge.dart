import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';

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
  }) : color = accent,
       background = accentLight,
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
  }) : color = accent,
       background = accentLight,
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
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dense ? 12 : 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: dense ? 11 : 12,
                fontFamily: "Bold",
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
