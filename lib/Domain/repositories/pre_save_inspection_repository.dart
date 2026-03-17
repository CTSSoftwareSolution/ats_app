
import 'package:flutter/cupertino.dart';

import '../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../entities/pre_save_inspection_entity.dart';

abstract class PreSaveInspectionRepository {

  Future<PreSaveInspectionEntity> preSaveInspection({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,

  });

}