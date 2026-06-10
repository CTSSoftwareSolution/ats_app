import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';



class BuildHeaderHome extends StatelessWidget {
  const BuildHeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                appColor,appColor.withValues(alpha: 0.75)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: appColor.withValues(alpha: 0.30),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: CustomImage(image: lmsLogo, height: 75, width: double.infinity),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: appColor,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  Preferences.getLocation(),
                  style:  TextStyle(
                    color: blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




