import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class InspectionResultScreenItem extends StatelessWidget {
  final VoidCallback onPress;
  const InspectionResultScreenItem({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: "Reverse Light",fontFamily: "Bold", fontSize: 20.0,),
                SizedBox(height: 5.0,),
                Row(
                  children: [
                    CustomText(text: "Status: ",fontFamily: "Bold", fontSize: 16.0,),
                    CustomText(text: "Pass",fontFamily: "Bold", fontSize: 16.0,textColor: greenColor,),
                  ],
                ),
              ],
            ),
            CustomButton(
              width: 90,
              buttonText: "Action",
              onPress: onPress,
              backgroundColor: appColor,
              foregroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))
              ),
              fontSize: 16,
              fontFamily: "Bold",
            ),
          ],
        ),
      ),
    );
  }
}
