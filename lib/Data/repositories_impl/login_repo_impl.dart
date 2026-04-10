import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:ats_app/Domain/repositories/login_repository.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../model/response_model/login_res_model.dart';

class LoginRepoImpl implements LoginRepository{

@override
  Future<LoginEntity> loginApi(LoginReqModel loginReqModel) async{
  try{
    final response = await ApiService.post(loginReqModel, newLoginUrl);
    final model = LoginResModel.fromJson(response);
    return LoginEntity(message: model.message, success: model.success, data: model.data);
  }catch (e){
    throw Exception(e);
  }
}
}