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
    String subtitle,
    Widget child,
    VoidCallback onTap,
    ) {
  return InkWell(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(15),
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
              subtitle.isEmpty
                  ? Center(
                child: CustomText(
                  text: title,
                  fontSize: 16,
                  fontFamily: "ExtraBold",
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 16,
                    fontFamily: "ExtraBold",
                  ),
                  SizedBox(height: 3,),
                  CustomText(
                    text: subtitle,
                    fontSize: 12,
                    fontFamily: "Medium",
                    textColor: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(right: 15.0),
          child: child
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
