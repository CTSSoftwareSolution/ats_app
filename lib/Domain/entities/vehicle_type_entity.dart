import '../../Data/model/response_model/vehicle_type_res_model.dart';

class VehicleTypeEntity {
  bool? status;
  String? message;
  List<TypeDataModel>? data;

  VehicleTypeEntity({this.status, this.message, this.data});
}