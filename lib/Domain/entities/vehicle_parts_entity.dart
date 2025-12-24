import '../../Data/model/response_model/vehicle_parts_res_model.dart';

class VehiclePartsEntity {
  bool? status;
  String? message;
  List<PartsDataModel>? data;

  VehiclePartsEntity({this.message, this.data, this.status});
}