import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/send_otp_req_model.dart';
import 'package:ats_app/Data/model/response_model/send_otp_res_model.dart';
import 'package:ats_app/Domain/entities/send_otp_entity.dart';
import 'package:ats_app/Domain/repositories/send_otp_repository.dart';

import '../../Core/network/api_services.dart';

class SendOtpRepoImpl implements SendOtpRepository{
  @override
  Future<SendOtpEntity> sendOtpApi(SendOtpReqModel requestModel) async {
    try{
      final response = await ApiService.post(requestModel, forgotPasswordSendOtpUrl);
      final model = SendOtpResModel.fromJson(response);
      return SendOtpEntity(message: model.message, success: model.success, data: model.data,
      errors: model.errors, type: model.type);
    }catch (e){
      throw Exception(e);
    }
  }

}