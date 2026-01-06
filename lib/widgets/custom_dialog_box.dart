import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import '../utilities/image_data.dart';
import 'custom_button.dart';
import 'custom_text.dart';

customShowDialog({
  required BuildContext context,
  required String title,
  required String subTitle,
  required VoidCallback cancelClick,
  required VoidCallback okClick,
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
            GestureDetector(
              onTap: (){ context.pop(); },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    textColor: blackColor,
                  ),
                  CustomImage(image: closeIcon,scale: 20,)
                ],
              ),
            ),
            10.height,
            CustomText(
              text: subTitle,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              textColor: blackColor,
            ),
           15.height,
            Row(

              children: [
                Expanded(child: CustomButton(
                  width: 135.0,
                  height: 30.0,
                  buttonText: "Yes",
                  onPress: okClick,
                  backgroundColor: appColor,
                  foregroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fontSize: 15.0,
                ),),

                5.width,
                Expanded(child: CustomButton(
                  width: 135.0,
                  height: 30.0,
                  buttonText: "No",
                  onPress: cancelClick,
                  backgroundColor: greyColor,
                  foregroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fontSize: 15.0,
                ),)

              ],
            ),
          ],
        ),
      ),
    ),
  );
}
