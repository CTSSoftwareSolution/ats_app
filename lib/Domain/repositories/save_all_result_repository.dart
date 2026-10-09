import 'package:ats_app/Data/model/request_model/save_all_result_req_model.dart';
import 'package:ats_app/Domain/entities/save_all_result_entity.dart';

abstract class SaveAllResultRepository {
  Future<SaveAllResultEntity> saveAllResult(SaveAllResultReqModel requestModel);
}