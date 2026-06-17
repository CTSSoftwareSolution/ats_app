import 'package:ats_app/Domain/repositories/new_inspection_save_repository.dart';

import '../../Data/model/request_model/new_inspection_save_req_model.dart';
import '../entities/new_inspection_save_entity.dart';

class NewInspectionSaveUseCases {
  NewInspectionSaveRepository newInspectionSaveRepository;

  NewInspectionSaveUseCases({required this.newInspectionSaveRepository});

  Future<NewInspectionSaveEntity> execute({
    required String vehicleId,
    required String appointmentId,
    required String createdBy,
    required String questionId,
    required String result,
    required String severityLevel,
    required String observation,
    required List<NewInspectionSaveReqModel> saveInspectionReqModel,
  }) {
    return newInspectionSaveRepository.newSaveApi(
      vehicleId: vehicleId,
      appointmentId: appointmentId,
      createdBy: createdBy,
      questionId: questionId,
      result: result,
      severityLevel: severityLevel,
      observation: observation,
      saveInspectionReqModel: saveInspectionReqModel,
    );
  }
}
