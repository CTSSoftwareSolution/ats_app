import 'package:ats_app/Data/model/request_model/reset_password_req_model.dart';
import 'package:ats_app/Domain/entities/reset_password_entity.dart';
import 'package:ats_app/Domain/repositories/reset_password_repository.dart';

class ResetPasswordUseCases {
  ResetPasswordRepository resetPasswordRepository;

  ResetPasswordUseCases({required this.resetPasswordRepository});

  Future<ResetPasswordEntity> execute(ResetPasswordReqModel requestModel){
    return resetPasswordRepository.resetPasswordApi(requestModel);
  }
}