import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import '../entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> loginApi(LoginReqModel loginReqModel);
}