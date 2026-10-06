import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/new_app_theme/app_spacing.dart';


/// Flat brand header for the Home tab: logo and the current centre location.
class BuildHeaderHome extends StatelessWidget {
  const BuildHeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = (Preferences.getLocation() ?? "").toString();
    return Container(
      width: double.infinity,
      color: appColor,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.page, AppSpacing.md, AppSpacing.page, AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImage(image: lmsLogo, height: 60, width: double.infinity),
          if (location.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, color: textWhiteSub, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "SemiBold",
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
