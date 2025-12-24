import '../../Data/model/response_model/login_res_model.dart';

class LoginEntity {
  bool? status;
  String? message;
  List<LoginDataModel>? data;

  LoginEntity({this.data, this.message, this.status});
}