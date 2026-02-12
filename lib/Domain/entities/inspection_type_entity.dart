import '../../Data/model/response_model/inspection_type_res_model.dart';

class InspectionTypeEntity {
  bool? status;
  String? message;
  List<InspectionTypeData>? data;

  InspectionTypeEntity({this.status, this.message, this.data});
}