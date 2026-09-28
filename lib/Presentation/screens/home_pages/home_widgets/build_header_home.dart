import 'package:ats_app/utilities/app_theme.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';



class BuildHeaderHome extends StatelessWidget {
  const BuildHeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = (Preferences.getLocation() ?? '').toString();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          CustomImage(image: lmsLogo, height: 60, width: double.infinity),
          if (location.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_rounded, color: whiteColor, size: 15),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: whiteColor,
                        fontSize: 12,
                        fontFamily: "SemiBold",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
