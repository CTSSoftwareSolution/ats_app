import '../../Data/model/response_model/vehicle_class_res_model.dart';

class VehicleClassEntity {
  bool? status;
  String? message;
  List<ClassDataModel>? data;

  VehicleClassEntity({this.data, this.message, this.status});
}