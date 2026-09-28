import 'dart:io';

import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/screens/manual_inspection_images/document_manual_doc_models.dart';
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
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/app_ui.dart';
import '../../provider/inspection_form_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../camera_page/camera_screen.dart';
import '../pre_inspection_form/inspection_page/inspection_page.dart';
import '../vehicle_test_parameter/vehicle_parts_screen.dart';


class ManualInspectionImageScreen extends StatefulWidget {
  const ManualInspectionImageScreen({super.key});

  @override
  State<ManualInspectionImageScreen> createState() => _ManualInspectionImageScreenState();
}

class _ManualInspectionImageScreenState extends State<ManualInspectionImageScreen>  with WidgetsBindingObserver{

  int missingCount = 0;

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
    final detailsProvider = Provider.of<AiInspectionDetailsProvider>(context, listen: false);

    List<DocumentManualDocModels> docs = [];
    for (int i = 0; i < cameraController.mediaFile.length; i++) {
      final image = cameraController.mediaFile[i];
      if(image != null && image.image != null && image.image!.path.isNotEmpty){
        docs.add(
          DocumentManualDocModels(
            labelId: "${i+1}",
            latitude: location.currentPosition!.latitude.toString(),
            longitude: location.currentPosition!.longitude.toString(),
            file: File(image.image!.path),
          ),
        );
      }
    }
    int remaining = 8 - docs.length;
    if (remaining > 0) {
      String message = remaining == 1
          ? "$remaining image remaining to upload"
          : "$remaining images remaining to upload";

      CustomLoader.message(message);
      return;
    }
     await provider.uploadDocuments(
      appointmentId: vehicleClassProvider.selectedClass!.appointmentId.toString(),
      createdBy: Preferences.getUserId().toString(),
      vehicleId: vehicleClassProvider.selectedClass!.vehicleKey.toString(),
      documents: docs,
    );
    if (!mounted) return;

    context.push(VehiclePartsScreen());
      // showInspectionSheet(context,
      //   onSelect: (value) {
      //     final provider = context.read<InspectionFormProvider>();
      //
      //     if (value == 'Visual Inspection') {
      //       debugPrint('Visual Inspection');
      //       provider.setInspectionMode(InspectionMode.visualInspection,);
      //       context.push(InspectionPage(isEditMode: false),);
      //     } else if (value == 'Under-PIT Inspection') {
      //       debugPrint('Under PIT Inspection');
      //       provider.setInspectionMode(InspectionMode.underPitInspection,);
      //       context.push(InspectionPage(isEditMode: false),);
      //     }
      //   },
      // );


    //cameraController.clearAll();
    //if(!mounted) return;
    // detailsProvider.setAIMode(false);
    // context.push(InspectionPage(isEditMode: false,));
      //context.push(VehiclePartsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    final selected = context.watch<VehicleClassProvider>().selectedClass;
    final regNo = selected?.registrationNo?.toString() ?? '';
    int captured = 0;
    for (int i = 0; i < labels.length; i++) {
      if (fileProvider.getMedia(i)?.image != null) captured++;
    }
    return Scaffold(
      appBar:  AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Gather Vehicle Data"),
            if (regNo.isNotEmpty)
              Text(
                regNo.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontFamily: "SemiBold",
                  color: textWhiteSub,
                  letterSpacing: 0.8,
                ),
              ),
          ],
        ),
        leading: AppBackButton(
          onPressed: (){
            context.pop();
            fileProvider.clearAll();
          },
        ),
      ),
      body: Column(
        children: [
          CaptureProgressHeader(
            title: "Mandatory vehicle photos",
            subtitle: captured == labels.length
                ? "All photos captured. Continue to upload."
                : "Capture all ${labels.length} photos to continue",
            done: captured,
            total: labels.length,
          ),
          const Divider(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 600 ? 3 : 2;
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.92,
                  ),
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    final isCaptured = fileProvider.getMedia(index)?.image != null;
                    return AppCard(
                      padding: const EdgeInsets.all(10),
                      borderColor: isCaptured ? pass.withValues(alpha: 0.35) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isCaptured ? pass : surface2,
                                  shape: BoxShape.circle,
                                ),
                                child: isCaptured
                                    ? const Icon(Icons.check_rounded, size: 14, color: whiteColor)
                                    : Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontFamily: "Bold",
                                          color: textSecondary,
                                        ),
                                      ),
                              ),
                              8.width,
                              Expanded(
                                child: Text(
                                  labels[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "SemiBold",
                                    fontSize: 13.5,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          8.height,
                          Expanded(
                            child: UploadImageContainer(
                              isVideo: false,
                              width: double.infinity,
                              buttonHeight: 30,
                              buttonWidth: 96,
                              iconSize: 38,
                              iconScale: 6.5,
                              text: "Required",
                              onTap: () async {
                                fileProvider.setVideo(false);
                                fileProvider.setCurrentIndex(index);
                               // await fileProvider.initCamera();
                                await context.push(CameraScreen());
                              },
                              index: index,
                              isTablet: false,
                              borderRadius: 10.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: captured == labels.length
              ? "Upload & Continue"
              : "Next  ($captured/${labels.length})",
          icon: Icons.cloud_upload_outlined,
          onPressed: (){
            imageUpload();
          },
        ),
      ),
    );
  }


}
