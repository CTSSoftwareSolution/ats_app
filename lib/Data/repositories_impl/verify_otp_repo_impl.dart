import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/verify_otp_req_model.dart';
import 'package:ats_app/Data/model/response_model/verify_otp_res_model.dart';
import 'package:ats_app/Domain/entities/verify_otp_entity.dart';
import 'package:ats_app/Domain/repositories/verify_otp_repository.dart';

import '../../Core/network/api_services.dart';

class VerifyOtpRepoImpl implements VerifyOtpRepository{
  @override
  Future<VerifyOtpEntity> verifyOtpApi(VerifyOtpReqModel requestModel) async {
    try{
      final response = await ApiService.post(requestModel, forgotPasswordVerifyOtpUrl);
      final model = VerifyOtpResModel.fromJson(response);
      return VerifyOtpEntity(message: model.message, success: model.success, data: model.data,
      type: model.type, errors: model.errors);
    }catch (e){
      throw Exception(e);
    }
  }



}