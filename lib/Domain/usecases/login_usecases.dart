import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:flutter/cupertino.dart';



import '../repositories/login_repository.dart';

class LoginUseCases {
  LoginRepository loginRepository;

  LoginUseCases({required this.loginRepository});

  Future<LoginEntity> execute(LoginReqModel loginReqModel){
    return loginRepository.loginApi(loginReqModel);
  }
}