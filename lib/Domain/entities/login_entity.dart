import '../../Data/model/response_model/login_res_model.dart';

class LoginEntity {
  bool? success;
  String? message;
  LoginDataModel? data;

  LoginEntity({this.data, this.message, this.success});
}