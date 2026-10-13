import 'package:ats_app/Data/model/request_model/send_otp_req_model.dart';
import 'package:ats_app/Domain/entities/send_otp_entity.dart';
import 'package:ats_app/Domain/repositories/send_otp_repository.dart';

class SendOtpUseCases {
  SendOtpRepository sendOtpRepository;

  SendOtpUseCases({required this.sendOtpRepository});

  Future<SendOtpEntity> execute(SendOtpReqModel requestModel){
    return sendOtpRepository.sendOtpApi(requestModel);
  }
}