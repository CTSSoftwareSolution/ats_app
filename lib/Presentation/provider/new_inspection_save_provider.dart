import 'package:ats_app/Domain/usecases/new_inspection_save_usecases.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/custom_loader.dart';

import '../../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../../../Domain/usecases/pre_save_inspection_usecase.dart';
import '../../Data/model/request_model/new_inspection_save_req_model.dart';

class NewInspectionSaveProvider extends ChangeNotifier {
  final NewInspectionSaveUseCases useCases;

  NewInspectionSaveProvider({required this.useCases});

  Future<void> newSaveApi({
    required String vehicleId,
    required String appointmentId,
    required String createdBy,
    required String questionId,
    required String result,
    required String severityLevel,
    required String observation,
    required List<NewInspectionSaveReqModel> saveInspectionReqModel,
    required BuildContext context,
  }) async {
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try {
      await useCases.execute(
        vehicleId: vehicleId,
        appointmentId: appointmentId,
        createdBy: createdBy,
        questionId: questionId,
        result: result,
        severityLevel: severityLevel,
        observation: observation,
        saveInspectionReqModel: saveInspectionReqModel,
      );
    } catch (e) {
      CustomLoader.closeLoader();
    }
    CustomLoader.closeLoader();
    notifyListeners();
  }
}
