class ChangePasswordEntity {
  bool? success;
      String? message;
  dynamic data;
      dynamic type;
  List<dynamic>? errors;

  ChangePasswordEntity({this.success, this.message, this.data, this.type, this.errors});
}