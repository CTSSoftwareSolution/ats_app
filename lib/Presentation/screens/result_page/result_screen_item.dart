import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../../../utilities/image_data.dart';

class ResultScreenItem extends StatelessWidget {
  const ResultScreenItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC5CAD8).withValues(alpha:0.35),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha:0.9),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Icon container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: const Color(0xFFF0F4FB),
                  ),
                  child: Center(
                    child: CustomImage(image: defaultImage, scale: 6.5),
                  ),
                ),
                14.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Headlights",
                        fontFamily: "Bold",
                        fontSize: 17.0,
                        textColor: const Color(0xFF1C2A45),
                      ),
                      5.height,
                      CustomText(
                        text: "Quick diagnostic of your headlights",
                        fontFamily: "Medium",
                        fontSize: 12.5,
                        textColor: const Color(0xFF8F9BB8),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            14.height,
            // Divider
            Container(
              height: 1,
              color: const Color(0xFFF0F2F7),
            ),
            12.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Pass badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 7.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: const Color(0xFFEDF7EF),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF3DB85C),
                        ),
                      ),
                      6.width,
                      CustomImage(image: passImage, scale: 6.0),
                      5.width,
                      CustomText(
                        text: "Pass",
                        fontFamily: "Bold",
                        fontSize: 12.5,
                        textColor: const Color(0xFF2A8C44),
                      ),
                    ],
                  ),
                ),
                10.width,
                // Fail badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 7.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: const Color(0xFFFDF0F0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD94040),
                        ),
                      ),
                      6.width,
                      CustomImage(image: failImage, scale: 6.0),
                      5.width,
                      CustomText(
                        text: "Fail",
                        fontFamily: "Bold",
                        fontSize: 12.5,
                        textColor: const Color(0xFFBF2E2E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}