import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// One part of an [AppSegmentedBar] / [AppSegmentLegend]: "3 uploaded".
class AppSegment {
  final int value;
  final String label;
  final Color color;

  /// Remaining / not-yet-done work: drawn as the neutral track in the bar
  /// and as a hollow dot in the legend.
  final bool remaining;

  /// Draw the legend text in [color] (e.g. failures).
  final bool emphasize;

  const AppSegment({
    required this.value,
    required this.label,
    required this.color,
    this.remaining = false,
    this.emphasize = false,
  });
}

/// Proportional bar of several states (pass / fail / pending, uploaded /
/// uploading / failed / required). Zero-value segments are skipped.
class AppSegmentedBar extends StatelessWidget {
  final List<AppSegment> segments;
  final double height;

  const AppSegmentedBar({super.key, required this.segments, this.height = 6});

  @override
  Widget build(BuildContext context) {
    final shown = segments.where((s) => s.value > 0).toList();
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: SizedBox(
          height: height,
          child: shown.isEmpty
              ? const ColoredBox(color: surface2)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final s in shown)
                      Expanded(
                        flex: s.value,
                        child: ColoredBox(
                          color: s.remaining ? surface2 : s.color,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// "● 2 pass  ● 1 fail  ○ 3 required" under an [AppSegmentedBar].
class AppSegmentLegend extends StatelessWidget {
  final List<AppSegment> segments;

  const AppSegmentLegend({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        for (final s in segments)
          if (s.value > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: s.remaining ? surface : s.color,
                    shape: BoxShape.circle,
                    border: s.remaining ? Border.all(color: borderDark) : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.iconGap),
                Text(
                  '${s.value} ${s.label}',
                  style: AppText.caption.copyWith(
                    color: s.emphasize ? s.color : textSecondary,
                    fontFeatures: AppText.tabular,
                  ),
                ),
              ],
            ),
      ],
    );
  }
}
