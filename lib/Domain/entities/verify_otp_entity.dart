class VerifyOtpEntity {
  bool? success;
      String? message;
  dynamic data;
      dynamic type;
  List<dynamic>? errors;

  VerifyOtpEntity({this.success, this.type, this.errors, this.data, this.message});
}