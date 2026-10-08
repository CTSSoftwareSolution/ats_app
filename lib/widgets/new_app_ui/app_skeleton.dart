import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_radius.dart';

/// Shimmer wrapper with the app's placeholder colours. Build the skeleton
/// from [SkeletonBox]es shaped like the real content, so nothing jumps when
/// data arrives.
class AppSkeleton extends StatelessWidget {
  final Widget child;

  const AppSkeleton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: ExcludeSemantics(
        child: Shimmer.fromColors(
          baseColor: surface2,
          highlightColor: surface,
          child: child,
        ),
      ),
    );
  }
}

/// One placeholder block inside an [AppSkeleton].
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = AppRadius.xs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
