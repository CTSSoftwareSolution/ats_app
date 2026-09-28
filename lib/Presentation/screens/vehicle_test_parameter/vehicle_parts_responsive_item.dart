import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../widgets/app_ui.dart';
import '../camera_page/camera_screen.dart';

class VehiclePartsResponsiveItem extends StatelessWidget {
  final dynamic item;
  final int allIndex;
  final bool isTablet;
  const VehiclePartsResponsiveItem({
    super.key,
    required this.item,
    required this.allIndex,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final media = context.watch<FileProvider>().getMedia(allIndex);
    final needsImage = item.type != 2;
    final needsVideo = item.type != 1;
    final isDone = (!needsImage || media?.image != null) &&
        (!needsVideo || media?.video != null);

    Widget buildImageContainer({required bool isVideo}) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (needsImage && needsVideo) ...[
              Text(
                isVideo ? "Video" : "Photo",
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "SemiBold",
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 6),
            ],
            UploadImageContainer(
              isVideo: isVideo,
              width: double.infinity,
              index: allIndex,
              image: isVideo ? videoUploadImage : pictureUploadImage,
              imageHeight: 22.0, imageWidth: 22.0,
              text: isVideo ? "Tap to capture video" : "Tap to capture image",
              onTap: () async {
                context.read<FileProvider>().setCurrentIndex(allIndex);
                context.read<FileProvider>().setVideo(isVideo);
                await context.push(CameraScreen());
              },
              isTablet: isTablet,
            ),
          ],
        ),
      );
    }

    return AppCard(
      borderColor: isDone ? pass.withValues(alpha: 0.35) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDone ? pass : accentLight,
                  shape: BoxShape.circle,
                ),
                child: isDone
                    ? const Icon(Icons.check_rounded, size: 18, color: whiteColor)
                    : Text(
                        "${allIndex + 1}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "Bold",
                          color: appColor,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.vehiclePartName.toString(),
                      style: const TextStyle(
                        fontFamily: "Bold",
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Capture or upload the ${item.vehiclePartName}",
                      style: const TextStyle(
                        fontFamily: "Medium",
                        fontSize: 13,
                        color: textSecondary,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // Wrap(
                    //   spacing: 6,
                    //   runSpacing: 6,
                    //   children: [
                    //     if (needsImage)
                    //       _RequirementChip(
                    //         icon: Icons.photo_camera_outlined,
                    //         label: "Photo required",
                    //         done: media?.image != null,
                    //       ),
                    //     if (needsVideo)
                    //       _RequirementChip(
                    //         icon: Icons.videocam_outlined,
                    //         label: "Video required",
                    //         done: media?.video != null,
                    //       ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.type == 1) ...[
                buildImageContainer(isVideo: false),
              ] else if (item.type == 2) ...[
                buildImageContainer(isVideo: true),
              ] else ...[
                buildImageContainer(isVideo: false),
                const SizedBox(width: 10),
                buildImageContainer(isVideo: true),
              ],
            ],
          ),
        ],
      ),
    );
  }

}

class _RequirementChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool done;

  const _RequirementChip({required this.icon, required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    return done
        ? StatusBadge(
            label: label.replaceFirst("required", "captured"),
            color: pass,
            background: passLight,
            icon: Icons.check_circle_rounded,
            dense: true,
          )
        : StatusBadge(
            label: label,
            color: warn,
            background: warnLight,
            icon: icon,
            dense: true,
          );
  }
}
