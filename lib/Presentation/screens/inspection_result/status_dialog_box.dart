import 'package:ats_app/Presentation/provider/inspection_result_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

statusDialogBox({required BuildContext context}) {


  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        padding: EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Change Status",
              fontSize: 16.0,
              fontFamily: "Medium",
              textColor: blackColor,
            ),
            20.height,
            Row(
              children: [
                CustomText(
                  text: "System Status - ",
                  fontSize: 16.0,
                  fontFamily: "Bold",
                  textColor: blackColor,
                ),
                CustomText(
                  text: "Pass",
                  fontSize: 16.0,
                  fontFamily: "Bold",
                  textColor: greenColor,
                ),
              ],
            ),
           10.height,
            Row(
              children: [
                CustomText(
                  text: "Current Staus - ",
                  fontSize: 16.0,
                  fontFamily: "Bold",
                  textColor: blackColor,
                ),
                CustomText(
                  text: "Pass",
                  fontSize: 16.0,
                  fontFamily: "Bold",
                  textColor: greenColor,
                ),
              ],
            ),
            30.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Change status to FAIL",
                  fontSize: 16.0,
                  fontFamily: "Bold",
                  textColor: blackColor,
                ),
                Checkbox(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(2.0))),
                  side: BorderSide(color: appColor,width: 2),
                  activeColor: appColor,
                    checkColor: whiteColor,
                    value: context.watch<InspectionResultProvider>().isChecked,
                    onChanged: (value){
                   context.read<InspectionResultProvider>().toggleCheckbox(value!);
                    }
                )
              ],
            ),

            CustomTextField(
              contentPadding: EdgeInsets.only(left: 10,right: 5,top: 15),
              fillColor: whiteColor,
              minLines: 3,
              hint: "Write a reason",
              controller: context.watch<InspectionResultProvider>().controller,
              hintStyle: TextStyle(fontFamily: "Medium", fontSize: 14,color: blackColor),
              readOnly: false,
              textCapitalization: TextCapitalization.words,
              inputFormatters: InputFormatters.descriptionValidation,
            ),
            30.height,
            CustomButton(
              width: double.infinity,
              height: 40,
              buttonText: "Submit",
              onPress: () {},
              backgroundColor: appColor,
              foregroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))
              ),
              fontSize: 16,
              fontFamily: "Bold",
            ),
          ],
        ),
      ),
    ),
  );
}
