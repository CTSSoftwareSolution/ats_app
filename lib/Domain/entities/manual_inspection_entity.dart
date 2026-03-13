
import '../../Data/model/response_model/manual_inspection_list_model.dart';

class ManualInspectionEntity {
  bool? status;
  String? message;
  ManualInsData? data;

  ManualInspectionEntity({this.status, this.message, this.data});
}