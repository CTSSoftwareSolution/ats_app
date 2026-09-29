import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/create_queue_provider.dart';
import '../../provider/vehicle_class_provider.dart';
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
    Widget buildImageContainer({required bool isVideo}) {
      return Expanded(
        child: UploadImageContainer(
          isVideo: isVideo,
          width: 180,
          index: allIndex,
          image: isVideo ? videoUploadImage : pictureUploadImage,
          imageHeight: 25.0,
          imageWidth: 25.0,
          text: isVideo ? "Tap to capture video" : "Tap to capture image",
          onTap: () async {
            debugPrint("[MEDIA] onTap triggered (index: $allIndex, isVideo: $isVideo)");
            final fileProvider = context.read<FileProvider>();

            fileProvider.setCurrentIndex(allIndex);
            fileProvider.setVideo(isVideo);

            debugPrint("[MEDIA] Opening CameraScreen");
            final result = await context.push(CameraScreen());
            debugPrint("[MEDIA] Camera result: $result");

            if (result == null) {
              debugPrint("[MEDIA] Early return: result is null");
              return;
            }

            final filePath = result.toString();
            debugPrint("[MEDIA] File path: $filePath");

            if (filePath.isEmpty) {
              debugPrint("[MEDIA] Early return: filePath is empty");
              return;
            }

            if (!context.mounted) {
              debugPrint("[MEDIA] Early return: context not mounted");
              return;
            }

            try {
              final classProvider = context.read<VehicleClassProvider>();

              final queueProvider = context.read<CreateQueueProvider>();

              final registrationNo =
                  classProvider.selectedClass!.registrationNo.toString();
              final applicationNo =
                  classProvider.selectedClass!.bookingId.toString();
              final questionId = item.questionId.toString();
              final inspectionId = item.id.toString();
              final imagePath = isVideo ? null : filePath;
              final videoPath = isVideo ? filePath : null;

              debugPrint("[MEDIA] Calling uploadMedia");
              debugPrint("[MEDIA] registrationNo: $registrationNo");
              debugPrint("[MEDIA] applicationNo: $applicationNo");
              debugPrint("[MEDIA] questionId: $questionId");
              debugPrint("[MEDIA] inspectionId: $inspectionId");
              debugPrint("[MEDIA] imagePath: $imagePath");
              debugPrint("[MEDIA] videoPath: $videoPath");

              final queueResult = await queueProvider.uploadMedia(
                registrationNo: registrationNo,
                applicationNo: applicationNo,
                questionId: questionId,
                inspectionId: inspectionId,
                imagePath: imagePath,
                videoPath: videoPath,
              );

              debugPrint(
                "[MEDIA] uploadMedia completed: success=${queueResult?.success}, "
                "error=${queueProvider.errorMessage}",
              );

              if (queueResult?.success != true && context.mounted) {
                CustomLoader.message(
                  queueProvider.errorMessage ?? 'Media upload failed',
                );
              }
            } catch (e, st) {
              debugPrint("[MEDIA] Exception before/while calling uploadMedia: $e\n$st");
            }
          },
          //     () async {
          //   context.read<FileProvider>().setCurrentIndex(allIndex);
          //   context.read<FileProvider>().setVideo(isVideo);
          //   await context.push(CameraScreen());
          // },
          isTablet: isTablet,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: appColor.withValues(alpha: 0.30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: item.vehiclePartName.toString(),
              fontFamily: "Bold",
              fontSize: 18.0,
            ),
            CustomText(
              text: "Capture or upload the ${item.vehiclePartName}",
              fontFamily: "Medium",
              fontSize: 15.0,
            ),
            isTablet ? 15.height : 20.height,
            Row(
              children: [
                if (item.type == 1) ...[
                  buildImageContainer(isVideo: false),
                ] else if (item.type == 2) ...[
                  buildImageContainer(isVideo: true),
                ] else ...[
                  buildImageContainer(isVideo: false),
                  SizedBox(width: 10),
                  buildImageContainer(isVideo: true),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
