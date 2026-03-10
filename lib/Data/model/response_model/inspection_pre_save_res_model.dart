class InspectionPreSaveResModel {

  bool? status;
  String? message;
  dynamic data;

  InspectionPreSaveResModel({
    this.status,
    this.message,
    this.data,
  });

  InspectionPreSaveResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

}