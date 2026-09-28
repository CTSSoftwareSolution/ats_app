import 'package:flutter/material.dart';

import '../../../widgets/app_ui.dart';

class ResponsiveButton extends StatelessWidget {
  final double width;
  final String buttonText;
  final VoidCallback onPress;
  const ResponsiveButton({super.key, required this.width, required this.buttonText, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: PrimaryButton(
        label: buttonText,
        onPressed: onPress,
        icon: buttonText == "Submit" ? Icons.cloud_upload_outlined : Icons.arrow_forward_rounded,
      ),
    );
  }
}
