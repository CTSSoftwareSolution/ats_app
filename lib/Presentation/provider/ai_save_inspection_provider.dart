
import 'package:ats_app/Domain/usecases/ai_save_inspection_usecases.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import '../../../Data/model/response_model/inspection_pre_save_req_model.dart';



class AiSaveInspectionProvider extends ChangeNotifier {

  final AISaveInspectionUseCase useCase;

  AiSaveInspectionProvider({required this.useCase});

  Future<void> aiSaveInspection({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,
    required BuildContext context
  }) async {
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try {
      await useCase.execute(
        appointmentId: appointmentId,
        inspectedBy: inspectedBy,
        vehicleId: vehicleId,
        inspections: inspections,
      );
    } catch (e) {
      CustomLoader.closeLoader();
    }
    CustomLoader.closeLoader();
    notifyListeners();
  }

}