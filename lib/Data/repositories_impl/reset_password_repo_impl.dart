import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/reset_password_req_model.dart';
import 'package:ats_app/Data/model/response_model/reset_password_res_model.dart';
import 'package:ats_app/Domain/entities/reset_password_entity.dart';
import 'package:ats_app/Domain/repositories/reset_password_repository.dart';

import '../../Core/network/api_services.dart';

class ResetPasswordRepoImpl implements ResetPasswordRepository{
  @override
  Future<ResetPasswordEntity> resetPasswordApi(ResetPasswordReqModel requestModel) async {
    try{
      final response = await ApiService.post(requestModel, forgotPasswordResetUrl);
      final model = ResetPasswordResModel.fromJson(response);
      return ResetPasswordEntity(message: model.message, success: model.success, data: model.data,
          errors: model.errors, type: model.type);
    }catch (e){
      throw Exception(e);
    }
  }



}