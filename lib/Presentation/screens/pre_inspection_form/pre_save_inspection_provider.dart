
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/custom_loader.dart';

import '../../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../../../Domain/usecases/pre_save_inspection_usecase.dart';


class PreSaveInspectionProvider extends ChangeNotifier {

  final PreSaveInspectionUseCase useCase;

  PreSaveInspectionProvider({required this.useCase});

  Future<void> preSaveInspection({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,
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