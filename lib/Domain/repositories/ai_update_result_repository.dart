import 'package:ats_app/Data/model/request_model/ai_update_result_req_model.dart';
import 'package:ats_app/Domain/entities/ai_update_result_entity.dart';

abstract class AiUpdateResultRepository {
  Future<AiUpdateResultEntity> updateAIResult(AiUpdateResultReqModel requestModel);
}