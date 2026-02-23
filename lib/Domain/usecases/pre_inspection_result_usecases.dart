import 'package:ats_app/Data/model/request_model/pre_inspection_result_req_model.dart';
import 'package:ats_app/Domain/entities/pre_inspection_result_entity.dart';
import 'package:ats_app/Domain/repositories/pre_inspection_result_repository.dart';


class PreInspectionResultUseCases {
  PreInspectionResultRepository preInspectionResultRepository;

  PreInspectionResultUseCases({required this.preInspectionResultRepository});

  Future<PreInspectionResultEntity> execute(PreInspectionResultReqModel resultReqModel){
    return preInspectionResultRepository.saveResult(resultReqModel);
  }

}