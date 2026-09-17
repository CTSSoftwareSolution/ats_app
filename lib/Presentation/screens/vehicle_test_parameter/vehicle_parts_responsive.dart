import 'dart:io';

import 'package:ats_app/Data/model/request_model/create_bulk_req_model.dart';
import 'package:ats_app/Presentation/provider/create_bulk_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_page/inspection_page.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/responsive_button.dart';

import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive_item.dart';
import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/custom_stepper.dart';
import '../../../utilities/extension.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/ai_inspection_details_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../../provider/vehicle_parts_provider.dart';
import '../inspection_result/inspection_result_screen.dart';

class VehiclePartsResponsiveLayout extends StatefulWidget {
  const VehiclePartsResponsiveLayout({super.key});

  @override
  State<VehiclePartsResponsiveLayout> createState() =>
      _VehiclePartsResponsiveLayoutState();
}

class _VehiclePartsResponsiveLayoutState
    extends State<VehiclePartsResponsiveLayout> {
  int allIndex = 0;
  @override
  Widget build(BuildContext context) {
    final partsProvider = context.watch<VehiclePartsProvider>();
    final fileProvider = context.watch<FileProvider>();

    return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: partsProvider.isLoading
                    ? Center(child: CustomLoader.loader())
                    : partsProvider.vehiclePartsEntity!.data!.isEmpty
                    ? Center(
                        child: CustomText(
                          text: partsProvider.vehiclePartsEntity!.message
                              .toString(),
                          fontFamily: "Bold",
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           25.height,
                          Center(
                            child: CustomStepper(
                              currentStep: partsProvider.currentStep,
                              totalStep:  partsProvider.totalPages,
                              width: double.infinity,
                            ),
                          ),
                          15.height,
                          Expanded(
                            child: ListView.builder(
                                    itemCount:
                                        partsProvider.currentPageData.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          partsProvider.currentPageData[index];
                                      allIndex =
                                          partsProvider.currentPage *
                                              partsProvider.itemsPerPage +
                                          index;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                        ),
                                        child: VehiclePartsResponsiveItem(
                                          item: item,
                                          allIndex: allIndex,
                                          isTablet: false,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          ResponsiveButton(
                                  width: double.infinity,
                                  buttonText:
                                      partsProvider.currentPage ==
                                          partsProvider.totalPages - 1
                                      ? "Submit"
                                      : "Next",
                                  onPress: () {
                                    final error = partsProvider.validateMedia(
                                      context: context,
                                    );

                                    if (error != null) {
                                      CustomLoader.message(error);
                                    } else {
                                      context.read<VehiclePartsProvider>().nextStepper(
                                            partsProvider.totalPages,
                                          );

                                      if (partsProvider.currentPage <
                                          partsProvider.totalPages - 1) {
                                        context.read<VehiclePartsProvider>()
                                            .nextPage(
                                              partsProvider.totalPages - 1,
                                            );
                                      } else {
                                        aiMediaUpload(context: context);
                                      }
                                    }
                                  },
                                ),
                        ],
                      ),
              ),
            );



  }

  static Future<void> aiMediaUpload({required BuildContext context}) async {
    final createController = Provider.of<CreateBulkProvider>(
      context,
      listen: false,
    );
    final classController = Provider.of<VehicleClassProvider>(
      context,
      listen: false,
    );
    final fileController = Provider.of<FileProvider>(context, listen: false);
    final partsController = Provider.of<VehiclePartsProvider>(
      context,
      listen: false,
    );
    final detailsController = Provider.of<AiInspectionDetailsProvider>(
      context,
      listen: false,
    );

    List<CreateBulkReqModel> questions = [];

    for (int i = 0; i < partsController.vehiclePartsEntity!.data!.length; i++) {
      final vehicleParts = partsController.vehiclePartsEntity!.data![i];
      final media = fileController.getMedia(i);

      questions.add(
        CreateBulkReqModel(
          questionId: vehicleParts.questionId.toString(),
          images: media?.image != null ? File(media!.image!.path) : null,
          videos: media?.video != null ? File(media!.video!.path) : null,
        ),
      );
    }

    await createController.uploadAIImage(
      registrationNumber: classController.selectedClass!.registrationNo
          .toString(),
      applicationNumber: classController.selectedClass!.bookingId.toString(),
      createdBy: Preferences.getUserId(),
      questions: questions,
      appointmentId: classController.selectedClass!.appointmentId.toString(),
    );

    detailsController.setAIMode(true);
    context.push(InspectionPage());
    context.read<VehiclePartsProvider>().resetStepper();
  }
}
