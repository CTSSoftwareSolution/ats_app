import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'new_app_ui/app_dialog.dart';

customShowDialog({
  required BuildContext context,
  required String title,
  required String subTitle,
  required VoidCallback cancelClick,
  required VoidCallback okClick,
  String cancelLabel = "No",
  String confirmLabel = "Yes",
  IconData icon = Icons.help_outline_rounded,
  bool destructive = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AppDialog(
      icon: icon,
      iconColor: destructive ? fail : appColor,
      title: title,
      message: subTitle,
      onClose: () => context.pop(),
      actions: [
        OutlinedButton(onPressed: cancelClick, child: Text(cancelLabel)),
        FilledButton(
          onPressed: okClick,
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: fail)
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}
