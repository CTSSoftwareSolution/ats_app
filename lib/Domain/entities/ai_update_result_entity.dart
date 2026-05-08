class AiUpdateResultEntity {
  bool? success;
  String? message;
  dynamic data;
  List<dynamic>? errors;

  AiUpdateResultEntity({this.success, this.message, this.data, this.errors});
}
