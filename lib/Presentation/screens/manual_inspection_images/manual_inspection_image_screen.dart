import 'dart:io';

import 'package:ats_app/Presentation/screens/manual_inspection_images/DocumentManualDocModels.dart';
import 'package:ats_app/Presentation/screens/manual_inspection_images/manual_ins_image_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import 'package:ats_app/location/location_provider.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/vehicle_class_provider.dart';
import '../camera_page/camera_screen.dart';
import '../pre_inspection_form/inspection_page/inspection_page.dart';

class ManualInspectionImageScreen extends StatefulWidget {
  const ManualInspectionImageScreen({super.key});

  @override
  State<ManualInspectionImageScreen> createState() => _ManualInspectionImageScreenState();
}

class _ManualInspectionImageScreenState extends State<ManualInspectionImageScreen>  with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      context.read<FileProvider>().clearImages();
      context.read<FileProvider>().clearAll();
    });
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void imageUpload() async {
    final provider = Provider.of<ManualInsImageProvider>(context, listen: false);
    final cameraController = Provider.of<FileProvider>(context, listen: false);
    final vehicleClassProvider = Provider.of<VehicleClassProvider>(context, listen: false);
    final location = Provider.of<LocationProvider>(context, listen: false);

    List<DocumentManualDocModels> docs = [];
    for (int i = 0; i < cameraController.images.length; i++) {
      final image = cameraController.images[i];
      if(image != null){
        docs.add(
          DocumentManualDocModels(
            labelId: "${i+1}",
            latitude: location.currentPosition!.latitude.toString(),
            longitude: location.currentPosition!.longitude.toString(),
            file: File(image.path),
          ),
        );
      }
    }
    int remaining = 8 - docs.length;
    if (remaining > 0) {
      CustomLoader.message("$remaining images remaining to upload");
      return;
    }
    await provider.uploadDocuments(
      appointmentId: vehicleClassProvider.selectedClass!.appointmentId.toString(),
      createdBy: Preferences.getUserId().toString(),
      vehicleId: vehicleClassProvider.selectedClass!.vehicleKey.toString(),
      documents: docs,
    );
    if(!mounted) return;
    context.push(InspectionPage(isEditMode: false,));
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: appColor,
        titleSpacing: 0,
        title: const CustomText(
          text: "Inspection Upload",
          fontFamily: "SemiBold",
          fontSize: 20,
        ),
      ),
          body: SafeArea(
              child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 15,left: 10,right: 10, bottom: 140),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1
                ),
                itemCount: labels.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:labels[index],
                          fontFamily: "Medium",
                          fontSize: 15.0,
                        ),
                        10.height,
                        Expanded(child:
                        UploadImageContainer(
                          buttonHeight: 28,
                          buttonWidth: 80,
                          iconSize: 40,
                          iconScale: 6.5,
                          onTap: () async {
                            fileProvider.setCurrentIndex(index);
                            context.push(CameraScreen());
                          },
                            index: index,
                            isTablet: false,
                          borderRadius: 5.0,
                        ))
                      ],
                    ),
                  );
                },
          ),
    ),
      floatingActionButton:
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: appColor,
              onPressed: (){
                imageUpload();
              },
              label: CustomText(text: "Next", fontSize: 18.0, fontFamily: "Bold",)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


}
