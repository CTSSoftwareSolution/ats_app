import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';

/// Loading placeholder with the same shape as the Home appointment card,
/// so the list doesn't jump when data arrives.
class AppointmentCardShimmer extends StatelessWidget {
  const AppointmentCardShimmer({super.key});

  Widget _block({
    double? width,
    required double height,
    double radius = AppRadius.sm,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Shimmer.fromColors(
        baseColor: surface2,
        highlightColor: surface,
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
                      _block(width: 128, height: 32, radius: 6),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _block(width: 56, height: 14),
                          const SizedBox(height: 4),
                          _block(width: 72, height: 12),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _block(width: 180, height: 16),
                  const SizedBox(height: 6),
                  _block(width: 120, height: 12),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _block(width: 56, height: 22),
                      const SizedBox(width: AppSpacing.sm),
                      _block(width: 64, height: 22),
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
              child: Row(
                children: [
                  // Flexible so narrow phones shrink these instead of
                  // overflowing.
                  Flexible(child: _block(width: 110, height: 20, radius: 100)),
                  const SizedBox(width: AppSpacing.md),
                  Flexible(child: _block(width: 110, height: 20, radius: 100)),
                  const SizedBox(width: AppSpacing.md),
                  const Spacer(),
                  _block(width: 84, height: 40, radius: AppRadius.sm + 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
