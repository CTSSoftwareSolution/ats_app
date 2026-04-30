import 'package:ats_app/Domain/entities/ai_save_inspection_entity.dart';

import '../../Data/model/response_model/inspection_pre_save_req_model.dart';


abstract class AISaveInspectionRepository {

  Future<AiSaveInspectionEntity> aiSaveInspection({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,

  });

}