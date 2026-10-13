import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/change_password_req_model.dart';
import 'package:ats_app/Data/model/response_model/change_password_res_model.dart';
import 'package:ats_app/Domain/entities/change_password_entity.dart';
import 'package:ats_app/Domain/repositories/change_password_repository.dart';

import '../../Core/network/api_services.dart';

class ChangePasswordRepoImpl implements ChangePasswordRepository{
  @override
  Future<ChangePasswordEntity> changePasswordApi(ChangePasswordReqModel requestModel) async {
    try{
      final response = await ApiService.post(requestModel, changePasswordUrl);
      final model = ChangePasswordResModel.fromJson(response);
      return ChangePasswordEntity(message: model.message, success: model.success, data: model.data,
          errors: model.errors, type: model.type);
    }catch (e){
      throw Exception(e);
    }
  }
}
