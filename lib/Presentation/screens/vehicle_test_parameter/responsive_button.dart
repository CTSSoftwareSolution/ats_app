import 'package:flutter/material.dart';

import '../../../widgets/app_ui.dart';
import '../../../widgets/new_app_ui/primary_button.dart';

/// Primary step action of the vehicle test parameter flow. Place it inside a
/// [BottomActionBar] so it stays pinned to the bottom of the screen.
class ResponsiveButton extends StatelessWidget {
  final double width;
  final String buttonText;
  final VoidCallback onPress;
  const ResponsiveButton({super.key, required this.width, required this.buttonText, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: PrimaryButton(label: buttonText, onPressed: onPress),
    );
  }
}
