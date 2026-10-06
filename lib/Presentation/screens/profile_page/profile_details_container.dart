import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';

import '../../../utilities/image_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_card.dart';

class ProfileDetailsContainer extends StatelessWidget {
  const ProfileDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final photo = (Preferences.getImage() ?? '').toString().trim();
    final hasPhoto = photo.isNotEmpty && photo != 'null';
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Semantics(
            image: true,
            label: 'Profile photo',
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasPhoto ? surface2 : accentLight,
                border: Border.all(color: border),
              ),
              // No stored photo: a brand-tinted person icon instead of the
              // bright default image asset.
              child: !hasPhoto
                  ? const Icon(Icons.person_rounded, size: 34, color: appColor)
                  : ClipOval(
                      // Inset keeps the default person placeholder clear of the
                      // circular clip.
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
                      color: textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.sm),
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
