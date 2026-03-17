import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> loginApi(LoginReqModel loginReqModel);
}