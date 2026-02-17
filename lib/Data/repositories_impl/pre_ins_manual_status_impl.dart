import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/pre_ins_manual_status_req_model.dart';
import 'package:ats_app/Data/model/response_model/pre_ins_manual_status_res_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_manual_status_entity.dart';
import 'package:ats_app/Domain/repositories/pre_ins_manual_status_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../Core/network/api_services.dart';
import '../../Presentation/screens/ip_config/ip_address_provider.dart';

class PreInsManualStatusImpl extends PreInsManualStatusRepository{
  @override
  Future<PreInsManualStatusEntity> getManualStatus(PreInsManualStatusReqModel manualStatusReqModel) async{
    //final baseUrl = context.read<IpAddressProvider>().baseUrl;
    try{
      final response = await ApiService.post(manualStatusReqModel, checkManualInsStatusUrl);
      final model = PreInsManualStatusResModel.fromJson(response);
      return PreInsManualStatusEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }

}