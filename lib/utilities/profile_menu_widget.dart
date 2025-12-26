import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text.dart';


Widget buildSection(List<Widget> tiles) {
  return Container(
      decoration:  BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Column(children: tiles));
}

Widget buildTile(
    String leadingImage,
    String title,
    String trailingImage,
    VoidCallback onTap,
    ) {
  return InkWell(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
            CircleAvatar(
            radius: 20.0,
            backgroundColor: appColor,
            child: AspectRatio(
              aspectRatio: 2,
              child: ClipOval(child: Image(image: AssetImage(leadingImage),color: whiteColor,)),
            ),
          ),
              SizedBox(width: 8),
              CustomText(
                text: title,
                fontSize: 15,
                fontFamily: "SemiBold",
              ),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(right: 15.0),
          child: Image.asset(trailingImage, height: 12),
        ),
      ],
    ),
  );
}


Widget buildProfileView({required String title, required String value}){
  return Padding(
    padding:  EdgeInsets.only(
      right: 10.0,
      left: 10.0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        CustomText(
          text: title,
          fontSize: 15,
          fontFamily: "Bold",
        ),

        CustomText(
          text: value,
          fontSize: 15,
          fontFamily: "Medium",
        )

      ],
    ),
  );
}
