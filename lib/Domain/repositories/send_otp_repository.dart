import 'package:ats_app/Data/model/request_model/send_otp_req_model.dart';
import 'package:ats_app/Domain/entities/send_otp_entity.dart';

abstract class SendOtpRepository {
  Future<SendOtpEntity> sendOtpApi(SendOtpReqModel requestModel);
}