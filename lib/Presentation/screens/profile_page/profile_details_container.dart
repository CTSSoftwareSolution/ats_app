import 'package:ats_app/utilities/app_theme.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/app_ui.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';

import '../../../utilities/image_data.dart';

class ProfileDetailsContainer extends StatelessWidget {
  const ProfileDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: surface2,
              border: Border.all(color: border),
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
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Preferences.getName(),
                  style: AppText.sectionTitle.copyWith(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: textMuted,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        Preferences.getEmail(),
                        style: AppText.bodySecondary,
                        maxLines: 1,
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
    );
  }
}
