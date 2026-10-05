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
}) {
  showDialog(
    context: context,
    barrierColor: navy.withValues(alpha: 0.45),
    builder: (BuildContext context) => AppDialog(
      icon: Icons.help_outline_rounded,
      title: title,
      message: subTitle,
      onClose: () => context.pop(),
      actions: [
        OutlinedButton(onPressed: cancelClick, child: const Text("No")),
        FilledButton(onPressed: okClick, child: const Text("Yes")),
      ],
    ),
  );
}
