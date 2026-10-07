import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/new_app_theme/app_text.dart';
import 'package:flutter/material.dart';

import '../widgets/new_app_ui/app_dialog.dart';

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
  String title = "Alert",
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
        title: title,
        message: text,
        onClose: () => Navigator.of(context).pop(),
        actions: [
          for (final button in buttons)
            FilledButton(
              onPressed: button.onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: button.backgroundColor ?? appColor,
                foregroundColor: button.textColor ?? textWhite,
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                textStyle: AppText.buttonCompact,
              ),
              child: Text(
                button.text,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
        ],
      );
    },
  );
}
