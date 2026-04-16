import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../widgets/custom_text.dart';
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
         imageHeight: 25.0, imageWidth: 25.0,
          text: isVideo ? "Tap to capture video" : "Tap to capture image",
          onTap: () async {
            context.read<FileProvider>().setCurrentIndex(allIndex);
            context.read<FileProvider>().setVideo(isVideo);
            await context.push(CameraScreen());
          },
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
           // Row(
           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
           //   children: [
           //     Expanded(
           //       child: UploadImageContainer(
           //         isVideo: false,
           //               width: 180,
           //               index: allIndex,
           //                onTap: () async {
           //                  context.read<FileProvider>().setCurrentIndex(allIndex);
           //                  context.read<FileProvider>().setVideo(false);
           //                 // await context.read<FileProvider>().initCamera();
           //                  await context.push(CameraScreen());
           //                },
           //                isTablet: isTablet,
           //              ),
           //     ),
           //     10.width,
           //     Expanded(
           //       child: UploadImageContainer(
           //         isVideo: true,
           //         width: 180,
           //         index: allIndex,
           //         text: "Tap to capture video",
           //         onTap: () async {
           //           context.read<FileProvider>().setCurrentIndex(allIndex);
           //           context.read<FileProvider>().setVideo(true);
           //           //await context.read<FileProvider>().initCamera();
           //           await context.push(CameraScreen());
           //           },
           //         isTablet: isTablet,
           //       ),
           //     ),
           //   ],
           //
           // ),
          ],
        ),
      ),
    );
  }

}


