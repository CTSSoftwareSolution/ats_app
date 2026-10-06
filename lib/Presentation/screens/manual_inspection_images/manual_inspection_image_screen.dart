import 'dart:io';

import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/screens/manual_inspection_images/document_manual_doc_models.dart';
import 'package:ats_app/Presentation/screens/manual_inspection_images/manual_ins_image_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import 'package:ats_app/location/location_provider.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';

import '../../../utilities/image_data.dart';

import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_back_button.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/bottom_action_bar.dart';
import '../../../widgets/new_app_ui/circular_progress_header.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/vehicle_class_provider.dart';
import '../camera_page/camera_screen.dart';

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

  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    int capturedCount = 0;
    for (int i = 0; i < labels.length; i++) {
      final path = fileProvider.getMedia(i)?.image?.path;
      if (path != null && path.isNotEmpty) capturedCount++;
    }
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: const Text("Gather Vehicle Data"),
        leading: AppBackButton(
          onPressed: (){
            context.pop();
            fileProvider.clearAll();
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CaptureProgressHeader(
              title: "Vehicle photos",
              subtitle: "Capture all ${labels.length} photos to continue",
              done: capturedCount,
              total: labels.length,
              trailingLabel: "$capturedCount/${labels.length} captured",
            ),
            const Divider(height: 1, thickness: 1, color: border),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.page),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisExtent: 206,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                ),
                itemCount: labels.length,
                itemBuilder: (context, index) {
                  final path = fileProvider.getMedia(index)?.image?.path;
                  final captured = path != null && path.isNotEmpty;
                  return AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    borderColor: captured ? pass.withValues(alpha: 0.35) : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.title,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        // captured
                        //     ?  StatusBadge.pass(label: "Captured", dense: true)
                        //     : SizedBox.shrink(), //const StatusBadge.pending(label: "Required", dense: true),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: UploadImageContainer(
                            isVideo: false,
                            width: double.infinity,
                            buttonHeight: 28,
                            buttonWidth: 80,
                            iconSize: 40,
                            iconScale: 6.5,
                            text: "Tap to capture",
                            onTap: () async {
                              fileProvider.setVideo(false);
                              fileProvider.setCurrentIndex(index);
                              await context.push(CameraScreen());
                            },
                            index: index,
                            isTablet: false,
                            borderRadius: 5.0,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            BottomActionBar(
              child: PrimaryButton(
                label: "Next",
                icon: Icons.arrow_forward_rounded,
                onPressed: (){
                  imageUpload();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}
