import 'package:ats_app/Data/model/request_model/change_password_req_model.dart';
import 'package:ats_app/Domain/entities/change_password_entity.dart';

abstract class ChangePasswordRepository {
  Future<ChangePasswordEntity> changePasswordApi(ChangePasswordReqModel requestModel);
}
