import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';

import '../../../utilities/image_data.dart';
import '../../../widgets/custom_text.dart';

class ProfileDetailsContainer extends StatelessWidget {
  const ProfileDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColor,
            appColor.withValues(alpha:0.75),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: appColor.withValues(alpha:0.38),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha:0.06),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 20.0),
            child: Row(
              children: [

                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.14),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha:0.9),
                      width: 2.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomImage(
                        image: Preferences.getImage(),
                        fit: BoxFit.cover,
                        switchToNetwork: true,
                        defaultImage: userImage,
                      ),
                    ),
                  ),
                ),
                16.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: Preferences.getName(),
                        fontSize: 20,
                        fontFamily: "Bold",
                        textColor: Colors.white,
                      ),
                      5.height,
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                          6.width,
                          Flexible(
                            child: CustomText(
                              text: Preferences.getEmail(),
                              fontSize: 13,
                              fontFamily: "Medium",
                              textColor: Colors.white.withValues(alpha:0.85),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}