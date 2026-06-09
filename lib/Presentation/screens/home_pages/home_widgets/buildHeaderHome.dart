import 'package:flutter/material.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/image_data.dart';
import '../../../../utilities/preferences.dart';
import '../../../../widgets/custom_image.dart';

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
                appColor,appColor.withOpacity(0.75)
                //Color(0xff5878f1), Color(0xff345afa), Color(0xff0f3af8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: appColor.withOpacity(0.30),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: CustomImage(image: lmsLogo, height: 75, width: double.infinity),
        ),
      //  SizedBox(height: 10),
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

class _LogoBadge extends StatelessWidget {
  final String image;
  const _LogoBadge({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomImage(image: image, height: 38, width: 38),
    );
  }
}


