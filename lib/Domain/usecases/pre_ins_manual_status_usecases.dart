import 'package:ats_app/Data/model/request_model/pre_ins_manual_status_req_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_manual_status_entity.dart';
import 'package:ats_app/Domain/repositories/pre_ins_manual_status_repository.dart';


class PreInsManualStatusUseCases {
  PreInsManualStatusRepository preInsManualStatusRepository;

  PreInsManualStatusUseCases({required this.preInsManualStatusRepository});

  Future<PreInsManualStatusEntity> execute(PreInsManualStatusReqModel manualStatusReqModel){
    return preInsManualStatusRepository.getManualStatus(manualStatusReqModel);
  }
}