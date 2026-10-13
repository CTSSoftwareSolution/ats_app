import 'package:ats_app/Data/model/request_model/verify_otp_req_model.dart';
import 'package:ats_app/Domain/entities/verify_otp_entity.dart';
import 'package:ats_app/Domain/repositories/verify_otp_repository.dart';

class VerifyOtpUseCases {
  VerifyOtpRepository verifyOtpRepository;

  VerifyOtpUseCases({required this.verifyOtpRepository});

  Future<VerifyOtpEntity> execute(VerifyOtpReqModel requestModel){
    return verifyOtpRepository.verifyOtpApi(requestModel);
  }
}