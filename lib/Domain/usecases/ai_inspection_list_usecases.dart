import 'package:ats_app/Data/model/request_model/ai_inspection_list_req_model.dart';
import 'package:ats_app/Domain/entities/ai_inspection_list_entity.dart';
import 'package:ats_app/Domain/repositories/ai_inspection_list_repository.dart';

class AiInspectionListUseCases {
  AiInspectionListRepository aiInspectionListRepository;

  AiInspectionListUseCases({required this.aiInspectionListRepository});

  Future<AiInspectionListEntity> execute(AiInspectionListReqModel requestModel){
    return aiInspectionListRepository.aiInspectedList(requestModel);
  }
}