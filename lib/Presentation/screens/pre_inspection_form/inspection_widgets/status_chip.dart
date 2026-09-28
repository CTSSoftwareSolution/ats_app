import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha:0.3), width: 1),
      ),
      child: Text(
        label,
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
