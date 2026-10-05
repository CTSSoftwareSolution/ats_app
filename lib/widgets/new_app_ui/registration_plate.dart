import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';

class RegistrationPlate extends StatelessWidget {
  final String number;
  final double fontSize;

  const RegistrationPlate({super.key, required this.number, this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textPrimary, width: 1.4),
      ),
      child: Text(
        number.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: "Bold",
          fontSize: fontSize,
          color: textPrimary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}