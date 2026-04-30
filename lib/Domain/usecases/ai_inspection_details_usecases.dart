import 'package:ats_app/Data/model/request_model/pre_inspection_details_req_model.dart';
import 'package:ats_app/Domain/repositories/ai_inspection_details_repository.dart';

import '../entities/pre_inspection_details_entity.dart';

class AIInspectionDetailsUseCases {
  AIInspectionDetailsRepository detailsRepository;

  AIInspectionDetailsUseCases({required this.detailsRepository});

  Future<PreInspectionDetailsEntity> execute(PreInspectionDetailsReqModel requestModel){
    return detailsRepository.aiInspectionDetailsApi(requestModel);
  }
}