import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';

/// Loading placeholder matching the Home / Result list cards.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  Widget _block({double? width, required double height, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
              Row(
                children: [
                  _block(width: 120, height: 30),
                  const Spacer(),
                  _block(width: 56, height: 24, radius: 100),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _block(width: 64, height: 22, radius: AppRadius.sm),
                  const SizedBox(width: AppSpacing.sm),
                  _block(width: 72, height: 22, radius: AppRadius.sm),
                  const SizedBox(width: AppSpacing.sm),
                  _block(width: 56, height: 22, radius: AppRadius.sm),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _block(height: 1, radius: 0),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _block(height: 12)),
                  const SizedBox(width: AppSpacing.xl),
                  Expanded(child: _block(height: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
