import 'package:flutter/material.dart';
import '../../../../widgets/new_app_ui/app_skeleton.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';

/// Loading placeholder with the same shape as the Home appointment card
/// (plate + status, vehicle lines + time, progress, stages + action), so the
/// list doesn't jump when data arrives.
class AppointmentCardShimmer extends StatelessWidget {
  const AppointmentCardShimmer({super.key});

  Widget _block({
    double? width,
    required double height,
    double radius = AppRadius.sm,
  }) => SkeletonBox(width: width, height: height, radius: radius);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: AppSkeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                AppSpacing.card,
                AppSpacing.card,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: _block(width: 120, height: 30)),
                      const Spacer(),
                      _block(width: 84, height: 22, radius: AppRadius.full),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _block(width: 180, height: 16),
                            const SizedBox(height: AppSpacing.xs),
                            _block(width: 120, height: 13),
                            const SizedBox(height: AppSpacing.xs),
                            _block(width: 140, height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _block(width: 44, height: 14),
                          const SizedBox(height: AppSpacing.xs),
                          _block(width: 52, height: 12),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _block(height: 1, radius: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                AppSpacing.md,
                AppSpacing.card,
                AppSpacing.md,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Flexible so narrow phones shrink these instead of
                      // overflowing.
                      Flexible(
                        child: _block(
                          width: 112,
                          height: 20,
                          radius: AppRadius.full,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Flexible(
                        child: _block(
                          width: 96,
                          height: 20,
                          radius: AppRadius.full,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: _block(height: 4, radius: AppRadius.xs)),
                      const SizedBox(width: AppSpacing.lg),
                      _block(width: 92, height: 40, radius: AppRadius.md),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
