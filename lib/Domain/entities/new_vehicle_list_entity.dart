import '../../Data/model/response_model/new_vehicle_list_res_model.dart';

class NewVehicleListEntity {
  bool? success;
  String? message;
  NewVehicleListData? data;
  dynamic type;
  List<dynamic>? errors;

  NewVehicleListEntity({this.success, this.message, this.data, this.type, this.errors});

}