import 'package:ats_app/Data/model/request_model/ai_result_req_model.dart';
import 'package:ats_app/Data/model/response_model/ai_result_response.dart';
import 'package:ats_app/Domain/entities/ai_result_entity.dart';
import 'package:ats_app/Domain/repositories/ai_result_repository.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';



class AiResultRepoImpl implements AiResultRepository{

  @override
  Future<AiResultEntity> aiResultDetails(AiResultReqModel requestModel) async{
    try{
      final response = await ApiService.post(requestModel, aiResultUrl);
      final model = AiResultResponse.fromJson(response);
      return AiResultEntity(message: model.message, data: model.data, success: model.success,
          errors: model.errors, type: model.type);
    }catch (e){
      throw Exception(e);
    }
  }
}