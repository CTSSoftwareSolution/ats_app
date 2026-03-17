

import 'package:ats_app/Data/model/request_model/manual_inspection_request.dart';
import 'package:ats_app/Data/model/response_model/manual_inspection_list_model.dart';
import 'package:ats_app/Domain/entities/manual_inspection_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class ManualInspectionRepository {
  Future<ManualInspectionEntity> getManualInspectionRepository(ManualInspectionRequest request);
}

