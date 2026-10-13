import 'package:ats_app/Data/model/request_model/reset_password_req_model.dart';
import 'package:ats_app/Domain/entities/reset_password_entity.dart';

abstract class ResetPasswordRepository {
  Future<ResetPasswordEntity> resetPasswordApi(ResetPasswordReqModel requestModel);
}