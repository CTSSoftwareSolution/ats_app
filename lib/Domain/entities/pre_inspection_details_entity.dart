import '../../Data/model/response_model/pre_inspection_details_model.dart';

class PreInspectionDetailsEntity {
  bool? status;
      String? message;
  PreInspectionDetailsData? data;

  PreInspectionDetailsEntity({this.status, this.data, this.message});
}