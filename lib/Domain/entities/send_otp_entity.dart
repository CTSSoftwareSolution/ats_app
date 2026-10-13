import '../../Data/model/response_model/send_otp_res_model.dart';

class SendOtpEntity {
  bool? success;
      String? message;
  sendOtpData? data;
      dynamic type;
  List<dynamic>? errors;

  SendOtpEntity({this.message, this.data, this.errors, this.type, this.success});
}