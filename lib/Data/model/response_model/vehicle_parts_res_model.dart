import 'package:ats_app/Domain/entities/vehicle_parts_entity.dart';

class VehiclePartsResModel extends VehiclePartsEntity {
  VehiclePartsResModel({
      bool? status, 
      String? message, 
      List<PartsDataModel>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  VehiclePartsResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(PartsDataModel.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<PartsDataModel>? _data;
VehiclePartsResModel copyWith({  bool? status,
  String? message,
  List<PartsDataModel>? data,
}) => VehiclePartsResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<PartsDataModel>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PartsDataModel {
  PartsDataModel({
      num? id, 
      String? vehicleClass, 
      String? vehiclePartName, 
      String? status,}){
    _id = id;
    _vehicleClass = vehicleClass;
    _vehiclePartName = vehiclePartName;
    _status = status;
}

  PartsDataModel.fromJson(dynamic json) {
    _id = json['Id'];
    _vehicleClass = json['vehicle_class'];
    _vehiclePartName = json['vehicle_part_name'];
    _status = json['status'];
  }
  num? _id;
  String? _vehicleClass;
  String? _vehiclePartName;
  String? _status;
  PartsDataModel copyWith({  num? id,
  String? vehicleClass,
  String? vehiclePartName,
  String? status,
}) => PartsDataModel(  id: id ?? _id,
  vehicleClass: vehicleClass ?? _vehicleClass,
  vehiclePartName: vehiclePartName ?? _vehiclePartName,
  status: status ?? _status,
);
  num? get id => _id;
  String? get vehicleClass => _vehicleClass;
  String? get vehiclePartName => _vehiclePartName;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['vehicle_class'] = _vehicleClass;
    map['vehicle_part_name'] = _vehiclePartName;
    map['status'] = _status;
    return map;
  }

}