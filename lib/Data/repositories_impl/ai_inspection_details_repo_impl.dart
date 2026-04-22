import 'package:ats_app/Data/model/request_model/pre_ins_details_req_model.dart';
import 'package:ats_app/Data/model/request_model/pre_inspection_details_req_model.dart';
import 'package:ats_app/Domain/entities/pre_inspection_details_entity.dart';
import 'package:ats_app/Domain/repositories/ai_inspection_details_repository.dart';

import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../model/response_model/pre_inspection_details_model.dart';

class AIInspectionDetailsRepoImpl implements AIInspectionDetailsRepository{

  @override
  Future<PreInspectionDetailsEntity> aiInspectionDetailsApi(PreInspectionDetailsReqModel requestModel) async{
    try{
      final response = await ApiService.post(requestModel, aiPreInspectionDetailsUrl);
      final model = PreInspectionDetailsModels.fromJson(response);
      return PreInspectionDetailsEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }

}