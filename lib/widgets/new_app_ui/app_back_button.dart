import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';

/// Back button for [AppTopBar]: Material rounded arrow, white on the brand
/// app bar, 48dp tap target from the theme.
class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: onPressed,
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: textWhite,
        size: AppIconSize.lg,
      ),
    );
  }
}
