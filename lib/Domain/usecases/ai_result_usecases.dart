import 'package:ats_app/Data/model/request_model/ai_result_req_model.dart';
import 'package:ats_app/Data/model/request_model/pre_inspection_details_req_model.dart';
import 'package:ats_app/Domain/entities/ai_result_entity.dart';
import 'package:ats_app/Domain/repositories/ai_inspection_details_repository.dart';
import 'package:ats_app/Domain/repositories/ai_result_repository.dart';

import '../entities/pre_inspection_details_entity.dart';

class AiResultUseCases {
  AiResultRepository resultRepository;

  AiResultUseCases({required this.resultRepository});

  Future<AiResultEntity> execute(AiResultReqModel requestModel){
    return resultRepository.aiResultDetails(requestModel);
  }
}