import 'package:ats_app/Data/model/request_model/pre_ins_manual_status_req_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_manual_status_entity.dart';

abstract class PreInsManualStatusRepository {
  Future<PreInsManualStatusEntity> getManualStatus(PreInsManualStatusReqModel manualStatusReqModel);
}