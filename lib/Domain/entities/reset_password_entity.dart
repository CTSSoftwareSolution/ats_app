class ResetPasswordEntity {
  bool? success;
      String? message;
  dynamic data;
      dynamic type;
  List<dynamic>? errors;

  ResetPasswordEntity({this.success, this.message, this.data, this.type, this.errors});
}