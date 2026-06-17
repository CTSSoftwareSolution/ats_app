
import 'package:ats_app/Data/model/request_model/new_inspection_save_req_model.dart';
import 'package:ats_app/Presentation/provider/new_vehicle_list_provider.dart';
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../../../provider/ai_inspection_details_provider.dart';
import '../../../provider/ai_save_inspection_provider.dart';
import '../../../provider/inspection_form_provider.dart';
import '../../../provider/manual_inspection_list_provider.dart';
import '../../../provider/new_inspection_save_provider.dart';
import '../../../provider/vehicle_class_provider.dart';
import '../../bottom_navigation/bottom_navigation_bar.dart';
import '../pre_save_inspection_provider.dart';

class ConfirmationDialog {
  static void show({
    required BuildContext context,
    required InspectionFormProvider provider,
    required bool isComplete,
    required int unanswered,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Row(
                children: [
                  Icon(
                    isComplete ? Icons.check_circle : Icons.warning_amber_rounded,///242424
                    color: isComplete ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Text(isComplete ? 'Submit Inspection?' : 'Incomplete!',style: TextStyle(fontSize: 20,fontFamily: "Medium"),),
                ],
              ),
                const SizedBox(height: 15),
          Text(
              isComplete
                  ? 'All ${provider.visibleTotalQuestions} questions answered. Ready to submit?'
                  : '$unanswered question(s) still unanswered.',
            style: TextStyle(fontSize: 16,fontFamily: "Regular"),
            ), const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: unanswered==0? Text("Cancel",style: TextStyle(fontSize: 14,fontFamily: "Bold"),):Text("Got it",style: TextStyle(fontSize: 16,fontFamily: "Bold"),),
                      ),
                      unanswered==0?
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isComplete ? Colors.green : const Color(0xFF1A3C6E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          if (isComplete) {
                            await newInspectionSaveAPI(context: context);
                            debugPrint("New Inspection Saved");
                          }
                          },
                        child: const Text('Submit'),
                      ):SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  //
  // static Future<void> preInspectionSaveAPI({required BuildContext context}) async {
  //   final provider = Provider.of<PreSaveInspectionProvider>(context, listen: false);
  //   final cameraController = Provider.of<FileProvider>(context, listen: false);
  //   final manualInspectionProvider = Provider.of<ManualInspectionListProvider>(context, listen: false);
  //
  //   final inspectionProvider = Provider.of<InspectionFormProvider>(context, listen: false);
  //     final vehicleListProvider = Provider.of<NewVehicleListProvider>(context, listen: false);
  //   List<InspectionPreSaveReqModel> inspections = [];
  //   for (final section in inspectionProvider.visibleSections) {
  //     for (final category in section.categories) {
  //       for (final q in category.questions) {
  //         if (q.carData.questionId == null) continue;
  //         if (q.answer == AnswerState.Fail && q.imagePath == null) {
  //           debugPrint("⚠Skipping Fail without image: Q${q.carData.questionId}");
  //           continue;
  //         }
  //         inspections.add(
  //           InspectionPreSaveReqModel(
  //             questionId: q.carData.questionId!.toString(),
  //             inspectionResult: q.answer.name,
  //             severityLevel: q.answer == AnswerState.Fail ? "High" : "Low",
  //             remarks: q.remark?.isEmpty ?? true ? "NA" : q.remark!,
  //             image1: q.imagePath,
  //           ),
  //         );
  //       }
  //     }
  //   }
  //   await provider.preSaveInspection(
  //     appointmentId: manualInspectionProvider.isManualInspectionScreen ?
  //     manualInspectionProvider.selectedManualListData!.appointmentId.toString() :
  //     vehicleListProvider.selectedVehicle!.appointmentId.toString(),
  //     vehicleId:  manualInspectionProvider.isManualInspectionScreen ?
  //     manualInspectionProvider.selectedManualListData!.vehicleKey.toString() :
  //     vehicleListProvider.selectedVehicle!.registrationNo.toString(),
  //     inspectedBy: Preferences.getUserId().toString(),
  //     inspections: inspections,
  //     context: context
  //   );
  //   cameraController.clearImages();
  //   if (!context.mounted) return;
  //   context.pushAndRemoveUntil(BottomNavigationBarScreen());
  //
  // }

  static Future<void> newInspectionSaveAPI({required BuildContext context}) async {
    final provider = Provider.of<NewInspectionSaveProvider>(context, listen: false);
    final cameraController = Provider.of<FileProvider>(context, listen: false);
    final inspectionProvider = Provider.of<InspectionFormProvider>(context, listen: false);
    final vehicleListProvider = Provider.of<NewVehicleListProvider>(context, listen: false);


    for (final section in inspectionProvider.visibleSections) {
      for (final category in section.categories) {
        for (final q in category.questions) {
          if (q.carData.questionId == null) continue;
          debugPrint("QuestionId: ${q.carData.questionId!.toString()}");
          debugPrint("Result: ${q.answer.name}");
          debugPrint("SeverityLevel: ${q.answer == AnswerState.Fail ? "High" : "Low"}");
          debugPrint("Observation: ${q.remark}");

          await provider.newSaveApi(
            vehicleId: vehicleListProvider.selectedVehicle!.registrationNo.toString(),
            appointmentId: vehicleListProvider.selectedVehicle!.appointmentId.toString(),
            createdBy: Preferences.getUserId().toString(),
            questionId: q.carData.questionId!.toString(),
            result: q.answer.name,
            severityLevel: q.answer == AnswerState.Fail ? "High" : "Low",
            observation: q.remark ?? '',
            saveInspectionReqModel: [
              NewInspectionSaveReqModel(
                labelId: '',
                latitude: '18.520430',
                longitude: '73.856744',
                file: q.imagePath,
              )
            ],
            context: context,
          );
          debugPrint("New Inspection Saved successful");
        }
      }
    }
    cameraController.clearImages();
    if (!context.mounted) return;
    context.pushAndRemoveUntil(BottomNavigationBarScreen());

  }

}