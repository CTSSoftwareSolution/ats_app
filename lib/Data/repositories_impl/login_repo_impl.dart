import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:ats_app/Domain/repositories/login_repository.dart';
import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../../Presentation/screens/ip_config/ip_address_provider.dart';
import '../model/response_model/login_res_model.dart';

class LoginRepoImpl implements LoginRepository{

@override
  Future<LoginEntity> loginApi(LoginReqModel loginReqModel) async{
  //final baseUrl = context.read<IpAddressProvider>().baseUrl;
  try{
    final response = await ApiService.post(loginReqModel, loginUrl);
    final model = LoginResModel.fromJson(response);
    return LoginEntity(message: model.message, status: model.status, data: model.data);
  }catch (e){
    throw Exception(e);
  }
}
}