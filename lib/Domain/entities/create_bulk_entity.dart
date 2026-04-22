class CreateBulkEntity {
  bool? success;
  String? message;
  dynamic data;
  List<dynamic>? errors;

  CreateBulkEntity({ this.success, this.message, this.data, this.errors});
}
