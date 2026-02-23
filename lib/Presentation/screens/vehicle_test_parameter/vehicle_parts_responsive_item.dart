import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/media_picker_tiles.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/MediaPicker/file_provider.dart';
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
    final image = context.watch<FileProvider>().getImage(allIndex);
    return Column(
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
        isTablet ? 15.height : 10.height,
       UploadImageContainer(

                index: allIndex,
                onTap: () {
                  context.read<FileProvider>().setCurrentIndex(allIndex);
                  context.push(CameraScreen());
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => CameraScreen()),
                  // );

                  // customBottomSheet(
                  //   context: context,
                  //   title: "Select Media",
                  //   child: mediaPickerTiles(context: context),
                  // );
                },
                isTablet: isTablet,
              ),
      ],
    );
  }
}
