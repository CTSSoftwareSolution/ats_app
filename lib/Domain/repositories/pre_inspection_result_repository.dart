import 'package:ats_app/Data/model/request_model/pre_inspection_result_req_model.dart';
import 'package:ats_app/Domain/entities/pre_inspection_result_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class PreInspectionResultRepository {
  Future<PreInspectionResultEntity> saveResult(PreInspectionResultReqModel resultModel);
}