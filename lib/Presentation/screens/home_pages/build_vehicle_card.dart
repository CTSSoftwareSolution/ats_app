import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget buildVehicleCard({
  required String title,
  required String imagePath,
  required VoidCallback onTap

}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Center(
          child: CustomText(text: title, fontSize: 16,fontFamily: "Bold", textColor: whiteColor,)
        ),
      ),
    ),
  );
}
