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
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/app_theme.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/custom_stepper.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/app_ui.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/new_app_ui/app_state_view.dart';
import '../../../widgets/new_app_ui/bottom_action_bar.dart';
import '../../../widgets/new_app_ui/status_badge.dart';
import '../../provider/ai_inspection_details_provider.dart';
import '../../provider/ai_result_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../../provider/vehicle_parts_provider.dart';
import '../inspection_result/inspection_result_screen.dart';
import '../ai_result/ai_result_screen.dart';

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

    if (partsProvider.isLoading) {
      return Center(child: CustomLoader.loader());
    }
    if (partsProvider.vehiclePartsEntity!.data!.isEmpty) {
      return Center(
        child: AppStateView(
          icon: Icons.inventory_2_outlined,
          title: "No parts to capture",
          message: partsProvider.vehiclePartsEntity!.message.toString(),
        ),
      );
    }

    final allParts = partsProvider.vehiclePartsEntity!.data!;
    int capturedCount = 0;
    for (int i = 0; i < allParts.length; i++) {
      if (VehiclePartsResponsiveItem.isCaptured(allParts[i], fileProvider.getMedia(i))) {
        capturedCount++;
      }
    }
    final allDone = capturedCount >= allParts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step indicator + overall capture progress
        Container(
          decoration: const BoxDecoration(
            color: surface,
            border: Border(bottom: BorderSide(color: border)),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Step ${partsProvider.currentStep + 1} of ${partsProvider.totalPages}",
                      style: AppText.sectionTitle,
                    ),
                  ),
                  allDone
                      ? StatusBadge.pass(label: "$capturedCount/${allParts.length} captured", dense: true)
                      : StatusBadge(
                          label: "$capturedCount/${allParts.length} captured",
                          color: appColor,
                          background: accentLight,
                          dense: true,
                        ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                "Capture the required media for each part below",
                style: AppText.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomStepper(
                currentStep: partsProvider.currentStep,
                totalStep: partsProvider.totalPages,
                width: double.infinity,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.page),
            itemCount: partsProvider.currentPageData.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = partsProvider.currentPageData[index];
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
            buttonText:
                partsProvider.currentPage ==
                    partsProvider.totalPages - 1
                ? "View Result"
                : "Next",
            onPress: () async {
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
                  context.read<VehiclePartsProvider>().nextPage(
                    partsProvider.totalPages - 1,
                  );
                } else {
                   //aiMediaUpload(context: context);
                  //  context.push(InspectionPage());
                  //  context.read<VehiclePartsProvider>().resetStepper();
                  CustomLoader.showLoader("Loading result...");
                  final result = await context
                      .read<AiResultProvider>()
                      .aiResultDetails(context);
                  if (!context.mounted) return;
                  if (result == null || result.success == false) {
                    CustomLoader.errorMessage(
                      (result?.message?.trim().isNotEmpty ?? false)
                          ? result!.message!.trim()
                          : "Unable to load result. Please try again.",
                    );
                    return;
                  }
                  context.push(const AiResultScreen());
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
