import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';

class ResultScreenItem extends StatelessWidget {
  const ResultScreenItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                CustomImage(image: defaultImage,scale: 4,),
                10.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Headlights",fontFamily: "Bold",fontSize: 20.0,),
                      CustomText(text: "Quick diagnostic of your headlights",fontFamily: "Medium",fontSize: 15.0,overflow: TextOverflow.visible,),
                    ],
                  ),
                ),
              ],
            ),
           5.height,
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomImage(image: passImage,scale: 4.5,),
                  5.width,
                  CustomText(text: "Pass",fontFamily: "Bold",fontSize: 16.0,textColor: greenColor,),
                  20.width,
                  CustomImage(image: failImage,scale: 4.5,),
                  5.width,
                  CustomText(text: "Fail",fontFamily: "Bold",fontSize: 16.0,textColor: redColor,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
