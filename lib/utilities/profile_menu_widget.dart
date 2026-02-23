import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text.dart';
import 'extension.dart';

Widget buildSection(List<Widget> tiles) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFC5CAD8).withValues(alpha: 0.28),
          blurRadius: 18,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Column(
        children: List.generate(tiles.length, (index) {
          return Column(
            children: [
              tiles[index],
              if (index < tiles.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(height: 1, color: const Color(0xFFF0F2F7)),
                ),
            ],
          );
        }),
      ),
    ),
  );
}

Widget buildTile(
  String leadingImage,
  String title,
  String subtitle,
  Widget child,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Leading icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: appColor.withValues(alpha: 0.10),
          ),
          child: Center(
            child: Image(
              image: AssetImage(leadingImage),
              width: 22,
              height: 22,
              color: appColor,
            ),
          ),
        ),
        12.width,
        // Text
        Expanded(
          child: subtitle.isEmpty
              ? CustomText(
                  text: title,
                  fontSize: 15.5,
                  fontFamily: "Bold",
                  textColor: const Color(0xFF1C2A45),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 15.5,
                      fontFamily: "Bold",
                      textColor: const Color(0xFF1C2A45),
                    ),
                    3.height,
                    CustomText(
                      text: subtitle,
                      fontSize: 12,
                      fontFamily: "Medium",
                      textColor: const Color(0xFF9AA3BB),
                    ),
                  ],
                ),
        ),
        // Trailing widget
        child,
      ],
    ),
  );
}

Widget buildProfileView({required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: title,
          fontSize: 14.5,
          fontFamily: "Bold",
          textColor: const Color(0xFF8F9BB8),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xFFF0F4FB),
          ),
          child: CustomText(
            text: value,
            fontSize: 14,
            fontFamily: "Medium",
            textColor: const Color(0xFF1C2A45),
          ),
        ),
      ],
    ),
  );
}
