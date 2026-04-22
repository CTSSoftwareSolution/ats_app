import 'package:ats_app/Data/model/request_model/pre_ins_details_req_model.dart';
import 'package:ats_app/Data/model/request_model/pre_inspection_details_req_model.dart';

import '../entities/pre_inspection_details_entity.dart';

abstract class AIInspectionDetailsRepository{
  Future<PreInspectionDetailsEntity> aiInspectionDetailsApi(PreInspectionDetailsReqModel requestModel);
}