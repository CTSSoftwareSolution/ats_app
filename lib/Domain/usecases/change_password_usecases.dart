import 'package:ats_app/Data/model/request_model/change_password_req_model.dart';
import 'package:ats_app/Domain/entities/change_password_entity.dart';
import 'package:ats_app/Domain/repositories/change_password_repository.dart';

class ChangePasswordUseCases {
  ChangePasswordRepository changePasswordRepository;

  ChangePasswordUseCases({required this.changePasswordRepository});

  Future<ChangePasswordEntity> execute(ChangePasswordReqModel requestModel){
    return changePasswordRepository.changePasswordApi(requestModel);
  }
}
