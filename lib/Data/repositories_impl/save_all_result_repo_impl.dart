import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/save_all_result_req_model.dart';
import 'package:ats_app/Data/model/response_model/save_all_result_res_model.dart';
import 'package:ats_app/Domain/entities/save_all_result_entity.dart';
import 'package:ats_app/Domain/repositories/save_all_result_repository.dart';

import '../../Core/network/api_services.dart';

class SaveAllResultRepoImpl implements SaveAllResultRepository{
  @override
  Future<SaveAllResultEntity> saveAllResult(SaveAllResultReqModel requestModel) async{
    try{
      final response = await ApiService.post(requestModel, saveAllResultUrl);
      final model = SaveAllResultResModel.fromJson(response);
      return SaveAllResultEntity(message: model.message, data: model.data, success: model.success,
          errors: model.errors, type: model.type);
    }catch (e){
      throw Exception(e);
    }
  }
}