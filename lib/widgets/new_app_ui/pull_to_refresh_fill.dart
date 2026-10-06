import 'package:flutter/material.dart';

/// Makes a non-scrolling, full-height child (empty / error state) draggable
/// so a parent [RefreshIndicator] can still be pulled when there is no list.
class PullToRefreshFill extends StatelessWidget {
  final Widget child;

  const PullToRefreshFill({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: constraints.maxHeight, child: child),
      ),
    );
  }
}
