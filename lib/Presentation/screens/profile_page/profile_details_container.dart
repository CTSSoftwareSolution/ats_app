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
        borderRadius: BorderRadius.circular(16.0),
        color: appColor,
      ),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
            child: Row(
              children: [

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
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
                        fontSize: 18,
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