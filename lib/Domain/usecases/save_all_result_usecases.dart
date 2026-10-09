import 'package:ats_app/Data/model/request_model/save_all_result_req_model.dart';
import 'package:ats_app/Domain/entities/save_all_result_entity.dart';
import 'package:ats_app/Domain/repositories/save_all_result_repository.dart';



class SaveAllResultUseCases {
  SaveAllResultRepository saveAllResultRepository;

  SaveAllResultUseCases({required this.saveAllResultRepository});

  Future<SaveAllResultEntity> execute(SaveAllResultReqModel request) {
    return saveAllResultRepository.saveAllResult(request);
  }
}