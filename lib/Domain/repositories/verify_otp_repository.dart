import 'package:ats_app/Data/model/request_model/verify_otp_req_model.dart';

import '../entities/verify_otp_entity.dart';

abstract class VerifyOtpRepository {
  Future<VerifyOtpEntity> verifyOtpApi(VerifyOtpReqModel requestModel);
}