import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/ai_inspection_list_req_model.dart';
import 'package:ats_app/Data/model/response_model/ai_inspection_list_res_model.dart';
import 'package:ats_app/Domain/entities/ai_inspection_list_entity.dart';
import 'package:ats_app/Domain/repositories/ai_inspection_list_repository.dart';

import '../../Core/network/api_services.dart';

class AiInspectionListRepoImpl implements AiInspectionListRepository{

  @override
  Future<AiInspectionListEntity> aiInspectedList(AiInspectionListReqModel requestModel) async{
    try{
      final response = await ApiService.post(requestModel, aiInspectionAppListUrl);
      final model = AiInspectionListResModel.fromJson(response);
      return AiInspectionListEntity(message: model.message, data: model.data, status: model.status);
    }catch (e){
      throw Exception(e);
    }
  }

}