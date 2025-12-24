import '../../../Domain/entities/vehicle_type_entity.dart';

class VehicleTypeResModel extends VehicleTypeEntity{
  VehicleTypeResModel({
      bool? status, 
      String? message, 
      List<TypeDataModel>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  VehicleTypeResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(TypeDataModel.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<TypeDataModel>? _data;
VehicleTypeResModel copyWith({  bool? status,
  String? message,
  List<TypeDataModel>? data,
}) => VehicleTypeResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<TypeDataModel>? get data => _data;

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

class TypeDataModel {
  TypeDataModel({
      num? id, 
      String? vehicleType, 
      String? description, 
      String? status, 
      dynamic imageUrl,}){
    _id = id;
    _vehicleType = vehicleType;
    _description = description;
    _status = status;
    _imageUrl = imageUrl;
}

  TypeDataModel.fromJson(dynamic json) {
    _id = json['Id'];
    _vehicleType = json['vehicle_type'];
    _description = json['description'];
    _status = json['status'];
    _imageUrl = json['imageUrl'];
  }
  num? _id;
  String? _vehicleType;
  String? _description;
  String? _status;
  dynamic _imageUrl;
  TypeDataModel copyWith({  num? id,
  String? vehicleType,
  String? description,
  String? status,
  dynamic imageUrl,
}) => TypeDataModel(  id: id ?? _id,
  vehicleType: vehicleType ?? _vehicleType,
  description: description ?? _description,
  status: status ?? _status,
  imageUrl: imageUrl ?? _imageUrl,
);
  num? get id => _id;
  String? get vehicleType => _vehicleType;
  String? get description => _description;
  String? get status => _status;
  dynamic get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['vehicle_type'] = _vehicleType;
    map['description'] = _description;
    map['status'] = _status;
    map['imageUrl'] = _imageUrl;
    return map;
  }

}