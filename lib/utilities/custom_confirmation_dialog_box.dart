import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import '../utilities/image_data.dart';
import '../widgets/custom_text.dart';

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
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
                child: InkWell(
                  onTap: (){ context.pop(); },
                    child: CustomImage(image: closeIcon,scale: 2,))),
            10.height,
            CustomText(
              text: text,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              textColor: blackColor,
            ),
            10.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: buttons.map((button) {
                return Expanded(
                  child: TextButton(onPressed: button.onPressed,
                      child: CustomText(text: button.text, textColor: button.textColor, fontSize: 13.5, fontFamily: "Bold",)
                  ),
                );
              }).toList(),
            ),


          ],
        ),
      ),
    ),
  );
}
