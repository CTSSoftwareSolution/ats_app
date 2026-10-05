import 'package:flutter/material.dart';

/// Small status pill used on category headers (Pass / Fail / Partial / Pending).
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  /// Optional fill; defaults to a light tint of [color].
  final Color? background;
  const StatusChip({super.key, required this.label, required this.color, this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontFamily: "Bold",
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
