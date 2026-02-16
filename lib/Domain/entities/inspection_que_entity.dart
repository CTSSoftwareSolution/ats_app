import '../../Data/model/response_model/inspection_que_model.dart';

class InspectionQueEntity {
  bool? status;
  String? message;
  InspectorData? data;

  InspectionQueEntity({this.status, this.message, this.data});
}