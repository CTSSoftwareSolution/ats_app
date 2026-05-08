import 'package:ats_app/Data/model/request_model/ai_update_result_req_model.dart';
import 'package:ats_app/Domain/entities/ai_update_result_entity.dart';
import 'package:ats_app/Domain/repositories/ai_update_result_repository.dart';

class AiUpdateResultUseCases {
  AiUpdateResultRepository aiUpdateResultRepository;

  AiUpdateResultUseCases({ required this.aiUpdateResultRepository});

  Future<AiUpdateResultEntity> execute(AiUpdateResultReqModel requestModel){
    return aiUpdateResultRepository.updateAIResult(requestModel);
  }

}