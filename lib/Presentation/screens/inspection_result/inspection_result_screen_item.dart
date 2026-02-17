import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class InspectionResultScreenItem extends StatelessWidget {
  final VoidCallback onPress;
  const InspectionResultScreenItem({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9BA8C3).withOpacity(0.18),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: icon + text
            Row(
              children: [
                // Icon box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        appColor.withOpacity(0.18),
                        appColor.withOpacity(0.07),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline_rounded,
                    color: appColor,
                    size: 22,
                  ),
                ),
                14.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Reverse Light",
                      fontFamily: "Bold",
                      fontSize: 16.0,
                      textColor: const Color(0xFF1A2340),
                    ),
                    6.height,
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFFEDF7EF),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF3DB85C),
                            ),
                          ),
                          5.width,
                          CustomText(
                            text: "Pass",
                            fontFamily: "Bold",
                            fontSize: 12.0,
                            textColor: const Color(0xFF2A8C44),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right: Action button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appColor,
                    appColor.withOpacity(0.80),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: appColor.withOpacity(0.32),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CustomButton(
                width: 88,
                height: 35,
                buttonText: "Action",
                onPress: onPress,
                backgroundColor: Colors.transparent,
                foregroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                fontSize: 13,
                fontFamily: "Bold",
              ),
            ),
          ],
        ),
      ),
    );
  }
}