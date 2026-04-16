class VehiclePartsResModel {
  VehiclePartsResModel({
      bool? success, 
      String? message, 
      List<PartsDataModel>? data,
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _errors = errors;
}

  VehiclePartsResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(PartsDataModel.fromJson(v));
      });
    }
    if (json['Errors'] != null) {
      _errors = [];
      // json['Errors'].forEach((v) {
      //   _errors?.add(Dynamic.fromJson(v));
      // });
    }
  }
  bool? _success;
  String? _message;
  List<PartsDataModel>? _data;
  List<dynamic>? _errors;
VehiclePartsResModel copyWith({  bool? success,
  String? message,
  List<PartsDataModel>? data,
  List<dynamic>? errors,
}) => VehiclePartsResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  List<PartsDataModel>? get data => _data;
  List<dynamic>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PartsDataModel {
  PartsDataModel({
      num? id, 
      String? vehiclePartName, 
      String? status, 
      String? vehicleClass, 
      num? type,}){
    _id = id;
    _vehiclePartName = vehiclePartName;
    _status = status;
    _vehicleClass = vehicleClass;
    _type = type;
}

  PartsDataModel.fromJson(dynamic json) {
    _id = json['id'];
    _vehiclePartName = json['vehicle_part_name'];
    _status = json['status'];
    _vehicleClass = json['vehicle_class'];
    _type = json['type'];
  }
  num? _id;
  String? _vehiclePartName;
  String? _status;
  String? _vehicleClass;
  num? _type;
  PartsDataModel copyWith({  num? id,
  String? vehiclePartName,
  String? status,
  String? vehicleClass,
  num? type,
}) => PartsDataModel(  id: id ?? _id,
  vehiclePartName: vehiclePartName ?? _vehiclePartName,
  status: status ?? _status,
  vehicleClass: vehicleClass ?? _vehicleClass,
  type: type ?? _type,
);
  num? get id => _id;
  String? get vehiclePartName => _vehiclePartName;
  String? get status => _status;
  String? get vehicleClass => _vehicleClass;
  num? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['vehicle_part_name'] = _vehiclePartName;
    map['status'] = _status;
    map['vehicle_class'] = _vehicleClass;
    map['type'] = _type;
    return map;
  }

}