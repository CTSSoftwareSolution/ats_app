import 'package:ats_app/Domain/entities/new_inspection_save_entity.dart';

import '../../Data/model/request_model/new_inspection_save_req_model.dart';

abstract class NewInspectionSaveRepository {
  Future<NewInspectionSaveEntity> newSaveApi({
    required String vehicleId,
    required String appointmentId,
    required String createdBy,
    required String questionId,
    required String result,
    required String severityLevel,
    required String observation,
    required List<NewInspectionSaveReqModel> saveInspectionReqModel,
  });
}
