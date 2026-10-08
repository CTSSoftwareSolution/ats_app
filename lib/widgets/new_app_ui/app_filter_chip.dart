import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_motion.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Single-select filter chip (lanes, vehicle class, upload filters,
/// question filters). Selected: brand fill with a check; unselected: white
/// with a hairline border. Optional [count] shows how many items match.
///
/// The visible chip is [AppSpacing.compactHeight] tall; transparent padding
/// extends the tap area to the 48dp minimum.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    final foreground = selected ? textWhite : textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Material(
            color: selected ? appColor : surface,
            animationDuration: AppMotion.fast,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: selected ? appColor : border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppSpacing.compactHeight,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selected) ...[
                      const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: textWhite,
                      ),
                      const SizedBox(width: AppSpacing.iconGap),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.chip.copyWith(color: foreground),
                      ),
                    ),
                    if (count != null) ...[
                      const SizedBox(width: AppSpacing.iconGap),
                      _Count(count: count!, selected: selected),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  final int count;
  final bool selected;

  const _Count({required this.count, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: selected ? textWhite.withValues(alpha: 0.2) : surface2,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: AppText.badgeDense.copyWith(
          color: selected ? textWhite : textSecondary,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
