import 'package:ats_app/Data/model/request_model/pre_ins_details_req_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_details_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class PreInsDetailsRepository {
  Future<PreInsDetailsEntity> preInspectionDetails(PreInsDetailsReqModel preInsDetailsReqModel);
}