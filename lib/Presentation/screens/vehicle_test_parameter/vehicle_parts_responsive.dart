import 'dart:io';

import 'package:ats_app/Data/model/request_model/create_bulk_req_model.dart';
import 'package:ats_app/Presentation/provider/create_bulk_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_page/inspection_page.dart';

import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive_item.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/media_upload_tracker.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_queue_sheet.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/custom_stepper.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/new_app_ui/app_state_view.dart';
import '../../../widgets/new_app_ui/bottom_action_bar.dart';
import '../../../widgets/new_app_ui/status_badge.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
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
  final MediaUploadTracker _uploadTracker = MediaUploadTracker();

  @override
  void dispose() {
    _uploadTracker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partsProvider = context.watch<VehiclePartsProvider>();
    final fileProvider = context.watch<FileProvider>();

    if (partsProvider.isLoading) {
      return CustomLoader.loader(message: "Loading vehicle parts…");
    }
    // The request failed (the provider clears the entity on error).
    if (partsProvider.vehiclePartsEntity?.data == null) {
      return Center(
        child: AppStateView.error(
          title: "Couldn't load vehicle parts",
          onAction: () => context.read<VehiclePartsProvider>().vehiclePartsApi(context),
        ),
      );
    }
    if (partsProvider.vehiclePartsEntity!.data!.isEmpty) {
      final message = partsProvider.vehiclePartsEntity!.message ?? '';
      return Center(
        child: AppStateView.empty(
          icon: Icons.inventory_2_outlined,
          title: "No parts to capture",
          message: message.isEmpty || message == 'null' ? null : message,
          onAction: () => context.read<VehiclePartsProvider>().vehiclePartsApi(context),
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

    // Parts on this step that still need media (for the Next button).
    int pageMissing = 0;
    for (int i = 0; i < partsProvider.currentPageData.length; i++) {
      final index = partsProvider.currentPage * partsProvider.itemsPerPage + i;
      if (!VehiclePartsResponsiveItem.isCaptured(
          partsProvider.currentPageData[i], fileProvider.getMedia(index))) {
        pageMissing++;
      }
    }
    final isLastStep = partsProvider.currentPage == partsProvider.totalPages - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step, overall capture progress and upload summary
        Container(
          decoration: const BoxDecoration(
            color: surface,
            border: Border(bottom: BorderSide(color: border)),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Step ${partsProvider.currentStep + 1} of ${partsProvider.totalPages}",
                      style: AppText.sectionTitle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    "$capturedCount of ${allParts.length} parts captured",
                    style: AppText.caption.copyWith(
                      color: allDone ? pass : textSecondary,
                      fontFamily: "SemiBold",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              CustomStepper(
                currentStep: partsProvider.currentStep,
                totalStep: partsProvider.totalPages,
                width: double.infinity,
              ),
              ListenableBuilder(
                listenable: _uploadTracker,
                builder: (context, _) => _UploadSummary(
                  tracker: _uploadTracker,
                  onViewAll: () => showUploadQueueSheet(
                    screenContext: this.context,
                    parts: allParts,
                    tracker: _uploadTracker,
                  ),
                ),
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
                tracker: _uploadTracker,
                totalParts: allParts.length,
              );
            },
          ),
        ),
        BottomActionBar(
          child: PrimaryButton(
            label: [
              isLastStep ? "View Result" : "Next",
              if (pageMissing > 0)
                pageMissing == 1 ? "1 part left" : "$pageMissing parts left",
            ].join(' · '),
            icon: isLastStep ? Icons.fact_check_outlined : Icons.arrow_forward_rounded,
            onPressed: () async {
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

/// Upload activity for this visit, in the header: how many media files are
/// uploaded / uploading, and a clear call-out when any upload failed.
class _UploadSummary extends StatelessWidget {
  final MediaUploadTracker tracker;

  /// Opens the upload queue sheet.
  final VoidCallback onViewAll;
  const _UploadSummary({required this.tracker, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final uploaded = tracker.uploadedCount;
    final uploading = tracker.uploadingCount;
    final failed = tracker.failedCount;

    if (uploaded == 0 && uploading == 0 && failed == 0) {
      return const Padding(
        padding: EdgeInsets.only(top: AppSpacing.sm),
        child: Text(
          "Capture the required photo/video for each part. Media uploads as soon as it's captured.",
          style: AppText.caption,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tappable row: counts on the left, "View uploads" on the right.
          Semantics(
            button: true,
            label: 'Uploads: $uploaded uploaded, $uploading uploading, $failed failed. View uploads',
            excludeSemantics: true,
            child: InkWell(
              onTap: onViewAll,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: [
                          if (uploaded > 0)
                            StatusBadge.uploaded(label: "$uploaded uploaded", dense: true),
                          if (uploading > 0)
                            StatusBadge.uploading(label: "$uploading uploading", dense: true),
                          if (failed > 0)
                            StatusBadge.error(label: "$failed failed", dense: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text("View uploads", style: AppText.chip.copyWith(color: appColor)),
                    const Icon(Icons.chevron_right_rounded, color: appColor, size: AppIconSize.md),
                  ],
                ),
              ),
            ),
          ),
          if (failed > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: failLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline_rounded, size: AppIconSize.sm + 2, color: fail),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      failed == 1
                          ? "1 upload failed. Tap Retry on the part marked in red, or open View uploads."
                          : "$failed uploads failed. Retry them from View uploads, or on the parts marked in red.",
                      style: AppText.caption.copyWith(color: fail, fontFamily: "SemiBold"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
