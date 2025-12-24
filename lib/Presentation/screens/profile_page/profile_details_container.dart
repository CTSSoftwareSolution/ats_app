import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';

import '../../../utilities/image_data.dart';
import '../../../widgets/custom_text.dart';


class ProfileDetailsContainer extends StatelessWidget {
  const ProfileDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                child: CustomImage(image: profileIcon,fit: BoxFit.fill,scale: 2,color: blackColor,),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Sanjay Sharma",
                    fontSize: 18,
                    fontFamily: "Bold",
                    textColor: whiteColor,
                  ),
                  CustomText(
                    text: "sanjay@gmail.com",
                    fontSize: 14,
                    fontFamily: "SemiBold",
                    textColor: whiteColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
