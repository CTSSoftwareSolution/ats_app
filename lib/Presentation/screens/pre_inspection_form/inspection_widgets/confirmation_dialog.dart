
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../../../../widgets/new_app_ui/app_dialog.dart';
import '../../../provider/ai_inspection_details_provider.dart';
import '../../../provider/ai_save_inspection_provider.dart';
import '../../../provider/inspection_form_provider.dart';
import '../../../provider/manual_inspection_list_provider.dart';
import '../../../provider/vehicle_class_provider.dart';
import '../../bottom_navigation/bottom_navigation_bar.dart';
import '../pre_save_inspection_provider.dart';
import '../../../../utilities/color_data.dart';
import '../../../../widgets/app_ui.dart';

class ConfirmationDialog {
  static void show({
    required BuildContext context,
    required InspectionFormProvider provider,
    required bool isComplete,
    required int unanswered,
  }) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        icon: isComplete ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
        iconColor: isComplete ? pass : warn,
        title: isComplete ? 'Submit Inspection?' : 'Incomplete!',
        message: isComplete
            ? 'All ${provider.visibleTotalQuestions} questions answered. Ready to submit?'
            : '$unanswered question(s) still unanswered.',
        actions: [
          unanswered == 0
              ? OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                )
              : FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Got it"),
                ),
          if (unanswered == 0)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isComplete ? pass : appColor,
              ),
              onPressed: () async {
                Navigator.pop(context);
                if (isComplete) {
                  final detailsProvider = context.read<AiInspectionDetailsProvider>();
                  if (detailsProvider.isAIMode) {
                    await aiPreInspectionSaveAPI(context: context);
                  } else {
                    preInspectionSaveAPI(context: context);
                  }
                }
              },
              child: const Text('Submit'),
            ),
        ],
      ),
    );
  }

  static Future<void> preInspectionSaveAPI({required BuildContext context}) async {
    final provider = Provider.of<PreSaveInspectionProvider>(context, listen: false);
    final cameraController = Provider.of<FileProvider>(context, listen: false);
    final manualInspectionProvider = Provider.of<ManualInspectionListProvider>(context, listen: false);

    final inspectionProvider = Provider.of<InspectionFormProvider>(context, listen: false);
    final vehicleClassProvider = Provider.of<VehicleClassProvider>(context, listen: false);
    List<InspectionPreSaveReqModel> inspections = [];
    for (final section in inspectionProvider.visibleSections) {
      for (final category in section.categories) {
        for (final q in category.questions) {
          if (q.carData.questionId == null) continue;
          if (q.answer == AnswerState.Fail && q.imagePath == null) {
            debugPrint("⚠Skipping Fail without image: Q${q.carData.questionId}");
            continue;
          }
          inspections.add(
            InspectionPreSaveReqModel(
              questionId: q.carData.questionId!.toString(),
              inspectionResult: q.answer.name,
              severityLevel: q.answer == AnswerState.Fail ? "High" : "Low",
              remarks: q.remark?.isEmpty ?? true ? "NA" : q.remark!,
              image1: q.imagePath,
            ),
          );
        }
      }
    }
    await provider.preSaveInspection(
      appointmentId: manualInspectionProvider.isManualInspectionScreen ?
      manualInspectionProvider.selectedManualListData!.appointmentId.toString() :
      vehicleClassProvider.selectedClass!.appointmentId.toString(),
      vehicleId:  manualInspectionProvider.isManualInspectionScreen ?
      manualInspectionProvider.selectedManualListData!.vehicleKey.toString() :
      vehicleClassProvider.selectedClass!.vehicleKey.toString(),
      inspectedBy: Preferences.getUserId().toString(),
      inspections: inspections,
      context: context
    );
    cameraController.clearImages();
    if (!context.mounted) return;
    context.pushAndRemoveUntil(BottomNavigationBarScreen());

  }


  static Future<void> aiPreInspectionSaveAPI({required BuildContext context}) async {
    final provider = Provider.of<AiSaveInspectionProvider>(context, listen: false);
    final cameraController = Provider.of<FileProvider>(context, listen: false);
    final manualInspectionProvider = Provider.of<ManualInspectionListProvider>(context, listen: false);

    final inspectionProvider = Provider.of<InspectionFormProvider>(context, listen: false);
    final vehicleClassProvider = Provider.of<VehicleClassProvider>(context, listen: false);
    List<InspectionPreSaveReqModel> inspections = [];
    for (final section in inspectionProvider.sections) {
      for (final category in section.categories) {
        for (final q in category.questions) {
          if (q.carData.questionId == null) continue;
          if (q.answer == AnswerState.Fail && q.imagePath == null) {
            debugPrint("⚠Skipping Fail without image: Q${q.carData.questionId}");
            continue;
          }
          inspections.add(
            InspectionPreSaveReqModel(
              questionId: q.carData.questionId!.toString(),
              inspectionResult: q.answer.name,
              severityLevel: q.answer == AnswerState.Fail ? "High" : "Low",
              remarks: q.remark?.isEmpty ?? true ? "NA" : q.remark!,
              image1: q.imagePath,
            ),
          );
        }
      }
    }
    await provider.aiSaveInspection(
        appointmentId: manualInspectionProvider.isManualInspectionScreen ? manualInspectionProvider.selectedManualListData!.appointmentId.toString() : vehicleClassProvider.selectedClass!.appointmentId.toString(),
        vehicleId:  manualInspectionProvider.isManualInspectionScreen ? manualInspectionProvider.selectedManualListData!.vehicleKey.toString() : vehicleClassProvider.selectedClass!.vehicleKey.toString(),
        inspectedBy: Preferences.getUserId().toString(),
        inspections: inspections,
        context: context
    );
    cameraController.clearImages();
    if (!context.mounted) return;
    context.pushAndRemoveUntil(BottomNavigationBarScreen());

  }
}