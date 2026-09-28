import 'dart:io';

import 'package:ats_app/Data/model/request_model/create_bulk_req_model.dart';
import 'package:ats_app/Presentation/provider/create_bulk_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_page/inspection_page.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/responsive_button.dart';

import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive_item.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../EmptyStateWidget.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../widgets/app_ui.dart';
import '../../../widgets/custom_loader.dart';
import '../../provider/ai_inspection_details_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../../provider/vehicle_parts_provider.dart';

class VehiclePartsResponsiveLayout extends StatefulWidget {
  const VehiclePartsResponsiveLayout({super.key});

  @override
  State<VehiclePartsResponsiveLayout> createState() =>
      _VehiclePartsResponsiveLayoutState();
}

class _VehiclePartsResponsiveLayoutState
    extends State<VehiclePartsResponsiveLayout> {
  int allIndex = 0;

  /// Number of test items whose required image/video has been captured.
  int _capturedCount(VehiclePartsProvider partsProvider, FileProvider fileProvider) {
    final data = partsProvider.vehiclePartsEntity?.data ?? [];
    int count = 0;
    for (int i = 0; i < data.length; i++) {
      final media = fileProvider.getMedia(i);
      final hasImage = media?.image != null;
      final hasVideo = media?.video != null;
      final type = data[i].type;
      final done = type == 1
          ? hasImage
          : type == 2
              ? hasVideo
              : hasImage && hasVideo;
      if (done) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final partsProvider = context.watch<VehiclePartsProvider>();
    final fileProvider = context.watch<FileProvider>();

    if (partsProvider.isLoading) {
      return Center(child: CustomLoader.loader());
    }
    if (partsProvider.vehiclePartsEntity!.data!.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.fact_check_outlined,
        title: 'No test parameters',
        subtitle: partsProvider.vehiclePartsEntity!.message.toString(),
      );
    }

    final totalItems = partsProvider.vehiclePartsEntity!.data!.length;
    final isLastPage = partsProvider.currentPage == partsProvider.totalPages - 1;
    final firstItem = partsProvider.currentPage * partsProvider.itemsPerPage + 1;
    final lastItem = firstItem + partsProvider.currentPageData.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CaptureProgressHeader(
          title: "Step ${partsProvider.currentPage + 1} of ${partsProvider.totalPages}",
          subtitle: "Items $firstItem–$lastItem of $totalItems  •  "
              "${_capturedCount(partsProvider, fileProvider)} captured",
          done: partsProvider.currentPage + 1,
          total: partsProvider.totalPages,
          trailingLabel: "${partsProvider.currentPage + 1}/${partsProvider.totalPages}",
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount:
                      partsProvider.currentPageData.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item =
                        partsProvider.currentPageData[index];
                    allIndex =
                        partsProvider.currentPage *
                            partsProvider.itemsPerPage +
                        index;
                    return VehiclePartsResponsiveItem(
                      item: item,
                      allIndex: allIndex,
                      isTablet: false,
                    );
                  },
                ),
        ),
        BottomActionBar(
          child: ResponsiveButton(
                width: double.infinity,
                buttonText: isLastPage ? "Submit" : "Next",
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
        ),
      ],
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
