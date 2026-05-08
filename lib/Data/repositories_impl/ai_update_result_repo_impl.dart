import 'package:ats_app/Core/network/api_services.dart';
import 'package:ats_app/Data/model/request_model/ai_update_result_req_model.dart';
import 'package:ats_app/Data/model/response_model/ai_update_result_res_model.dart';
import 'package:ats_app/Domain/entities/ai_update_result_entity.dart';
import 'package:ats_app/Domain/repositories/ai_update_result_repository.dart';

import '../../Core/network/services.dart';

class AiUpdateResultRepoImpl implements AiUpdateResultRepository{

  @override
  Future<AiUpdateResultEntity> updateAIResult(AiUpdateResultReqModel requestModel) async{

    try{
      final response = await ApiService.post(requestModel, aiUpdateQuestionResultUrl);
      final model = AiUpdateResultResModel.fromJson(response);
      return AiUpdateResultEntity(success: model.success, message: model.message, data: model.data, errors: model.errors );
    }catch (e){
      throw Exception(e);
    }
  }
  
}