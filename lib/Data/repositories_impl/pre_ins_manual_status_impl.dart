import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/pre_ins_manual_status_req_model.dart';
import 'package:ats_app/Data/model/response_model/pre_ins_manual_status_res_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_manual_status_entity.dart';
import 'package:ats_app/Domain/repositories/pre_ins_manual_status_repository.dart';

import '../../Core/network/api_services.dart';

class PreInsManualStatusImpl extends PreInsManualStatusRepository{
  @override
  Future<PreInsManualStatusEntity> getManualStatus(PreInsManualStatusReqModel manualStatusReqModel) async{
    try{
      final response = await ApiService.post(manualStatusReqModel, checkManualInsStatusUrl);
      final model = PreInsManualStatusResModel.fromJson(response);
      return PreInsManualStatusEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }

}