import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';

import '../../../utilities/image_data.dart';
import '../../../widgets/custom_text.dart';
import '../profile_view_edit_page/profile_view_edit_screen.dart';


class ProfileDetailsContainer extends StatelessWidget {
  const ProfileDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                    color: whiteColor,
                  shape: BoxShape.circle,),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                  child: CustomImage(image: Preferences.getImage(),fit: BoxFit.cover,switchToNetwork: true,defaultImage: userImage),
                )
              ),
            ),
            10.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: Preferences.getName(),
                  fontSize: 21,
                  fontFamily: "Bold",
                  textColor: whiteColor,
                ),
                3.height,
                CustomText(
                  text: Preferences.getEmail(),
                  fontSize: 14,
                  fontFamily: "SemiBold",
                  textColor: whiteColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
