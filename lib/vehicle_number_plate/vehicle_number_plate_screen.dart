import 'package:ats_app/Presentation/screens/camera_page/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Presentation/provider/MediaPicker/file_provider.dart';
import '../Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import '../utilities/color_data.dart';
import '../utilities/extension.dart';
import '../widgets/custom_text.dart';

class VehicleNumberPlateScreen extends StatefulWidget {
  const VehicleNumberPlateScreen({super.key});

  @override
  State<VehicleNumberPlateScreen> createState() =>
      _VehicleNumberPlateScreenState();
}

class _VehicleNumberPlateScreenState
    extends State<VehicleNumberPlateScreen> {

  static const int frontIndex = 0;
  static const int rearIndex = 1;

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FileProvider>();

    final frontImage = provider.getImage(frontIndex);
    final rearImage = provider.getImage(rearIndex);

    final bool canSave =
        frontImage != null && rearImage != null;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appColor,
        titleSpacing: 0.0,
        title: CustomText(
          text: "Detect Vehicle Number Plate",
          fontFamily: "SemiBold",
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                text: "Capture Front Registration Plate",
                fontSize: 16.0,
                fontFamily: "SemiBold",
              ),
              10.height,

              UploadImageContainer(
                index: frontIndex,
                isTablet: false,
                onTap: () async {
                  provider.setCurrentIndex(frontIndex);
                  await provider.initCamera();

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraScreen(),
                    ),
                  );
                },
              ),

              20.height,


              CustomText(
                text: "Capture Rear Registration Plate",
                fontSize: 16.0,
                fontFamily: "SemiBold",
              ),
              10.height,

              UploadImageContainer(
                index: rearIndex,
                isTablet: false,
                onTap: () async {
                  provider.setCurrentIndex(rearIndex);
                  await provider.initCamera();

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),


      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 15.0),
          child: FloatingActionButton.extended(
            backgroundColor:
            canSave ? appColor : Colors.grey,
            onPressed: canSave
                ? () {

            }
                : null,
            label: CustomText(
              text: "Save",
              fontSize: 18.0,
              fontFamily: "Bold",
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }
}
