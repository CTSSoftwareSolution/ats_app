import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text.dart';
import 'extension.dart';

Widget buildSection(List<Widget> tiles) {
  return Material(
    color: surface,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: const BorderSide(color: border),
    ),
    child: Column(
      children: List.generate(tiles.length, (index) {
        return Column(
          children: [
            tiles[index],
            if (index < tiles.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 72.0),
                child: Divider(),
              ),
          ],
        );
      }),
    ),
  );
}

Widget buildTile({
  String? leadingImage,
  String? title,
  String? subtitle,
  Widget? child,
  Color accent = appColor,
}) {
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
            color: accent.withValues(alpha: 0.10),
          ),
          child: Center(
            child: Image(
              image: AssetImage(leadingImage!),
              width: 22,
              height: 22,
              color: accent,
            ),
          ),
        ),
        12.width,
        // Text
        Expanded(
          child: subtitle!.isEmpty
              ? CustomText(
                  text: title!,
                  fontSize: 15,
                  fontFamily: "Bold",
                  textColor: accent == appColor ? textPrimary : accent,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title!,
                      fontSize: 15,
                      fontFamily: "Bold",
                      textColor: accent == appColor ? textPrimary : accent,
                    ),
                    3.height,
                    CustomText(
                      text: subtitle,
                      fontSize: 12,
                      fontFamily: "Medium",
                      textColor: textSecondary,
                    ),
                  ],
                ),
        ),
        // Trailing widget
        child!,
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


