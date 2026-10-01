import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

import '../widgets/app_ui.dart';

class DialogButton {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  DialogButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });
}

customConfirmationDialogBox({
  required BuildContext context,
  required String text,
  required List<DialogButton> buttons,
}) {
  showDialog(
    context: context,
    barrierColor: navy.withValues(alpha: 0.45),
    builder: (BuildContext context) {
      return AppDialog(
        title: "Alert",
        message: text,
        onClose: () => Navigator.of(context).pop(),
        actions: [
          for (final button in buttons)
            FilledButton(
              onPressed: button.onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: button.backgroundColor ?? appColor,
                foregroundColor: button.textColor ?? whiteColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                textStyle: const TextStyle(fontFamily: "SemiBold", fontSize: 14),
              ),
              child: Text(button.text, textAlign: TextAlign.center, maxLines: 2),
            ),
        ],
      );
    },
  );
}
