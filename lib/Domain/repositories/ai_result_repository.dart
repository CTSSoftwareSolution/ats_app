import 'package:ats_app/Data/model/request_model/ai_result_req_model.dart';
import 'package:ats_app/Domain/entities/ai_result_entity.dart';

abstract class AiResultRepository {
  Future<AiResultEntity> aiResultDetails(AiResultReqModel requestModel);
}