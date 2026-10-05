import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/image_data.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: onPressed,
      icon: ImageIcon( AssetImage(backArrowIcon), color: whiteColor, size: 20),
    );
  }
}