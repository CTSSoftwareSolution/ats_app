import 'package:ats_app/Domain/entities/vehicle_class_entity.dart';

class VehicleClassResModel extends VehicleClassEntity{
  VehicleClassResModel({
      bool? status, 
      String? message, 
      List<ClassDataModel>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  VehicleClassResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ClassDataModel.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<ClassDataModel>? _data;
VehicleClassResModel copyWith({  bool? status,
  String? message,
  List<ClassDataModel>? data,
}) => VehicleClassResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<ClassDataModel>? get data => _data;

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

class ClassDataModel {
  ClassDataModel({
      num? vehicleKey, 
      String? regNo, 
      String? vin, 
      String? engineNo, 
      String? vehicleClass, 
      String? vehicleCategory, 
      String? make, 
      String? model, 
      String? fuelType, 
      num? mfgMonth, 
      num? mfgYear, 
      num? gvw, 
      String? speedGovSn, 
      String? ownerType, 
      String? activeFrom, 
      dynamic activeTo, 
      bool? isCurrent,}){
    _vehicleKey = vehicleKey;
    _regNo = regNo;
    _vin = vin;
    _engineNo = engineNo;
    _vehicleClass = vehicleClass;
    _vehicleCategory = vehicleCategory;
    _make = make;
    _model = model;
    _fuelType = fuelType;
    _mfgMonth = mfgMonth;
    _mfgYear = mfgYear;
    _gvw = gvw;
    _speedGovSn = speedGovSn;
    _ownerType = ownerType;
    _activeFrom = activeFrom;
    _activeTo = activeTo;
    _isCurrent = isCurrent;
}

  ClassDataModel.fromJson(dynamic json) {
    _vehicleKey = json['vehicle_key'];
    _regNo = json['reg_no'];
    _vin = json['vin'];
    _engineNo = json['engine_no'];
    _vehicleClass = json['vehicle_class'];
    _vehicleCategory = json['vehicle_category'];
    _make = json['make'];
    _model = json['model'];
    _fuelType = json['fuel_type'];
    _mfgMonth = json['mfg_month'];
    _mfgYear = json['mfg_year'];
    _gvw = json['gvw'];
    _speedGovSn = json['speed_gov_sn'];
    _ownerType = json['owner_type'];
    _activeFrom = json['active_from'];
    _activeTo = json['active_to'];
    _isCurrent = json['is_current'];
  }
  num? _vehicleKey;
  String? _regNo;
  String? _vin;
  String? _engineNo;
  String? _vehicleClass;
  String? _vehicleCategory;
  String? _make;
  String? _model;
  String? _fuelType;
  num? _mfgMonth;
  num? _mfgYear;
  num? _gvw;
  String? _speedGovSn;
  String? _ownerType;
  String? _activeFrom;
  dynamic _activeTo;
  bool? _isCurrent;
  ClassDataModel copyWith({  num? vehicleKey,
  String? regNo,
  String? vin,
  String? engineNo,
  String? vehicleClass,
  String? vehicleCategory,
  String? make,
  String? model,
  String? fuelType,
  num? mfgMonth,
  num? mfgYear,
  num? gvw,
  String? speedGovSn,
  String? ownerType,
  String? activeFrom,
  dynamic activeTo,
  bool? isCurrent,
}) => ClassDataModel(  vehicleKey: vehicleKey ?? _vehicleKey,
  regNo: regNo ?? _regNo,
  vin: vin ?? _vin,
  engineNo: engineNo ?? _engineNo,
  vehicleClass: vehicleClass ?? _vehicleClass,
  vehicleCategory: vehicleCategory ?? _vehicleCategory,
  make: make ?? _make,
  model: model ?? _model,
  fuelType: fuelType ?? _fuelType,
  mfgMonth: mfgMonth ?? _mfgMonth,
  mfgYear: mfgYear ?? _mfgYear,
  gvw: gvw ?? _gvw,
  speedGovSn: speedGovSn ?? _speedGovSn,
  ownerType: ownerType ?? _ownerType,
  activeFrom: activeFrom ?? _activeFrom,
  activeTo: activeTo ?? _activeTo,
  isCurrent: isCurrent ?? _isCurrent,
);
  num? get vehicleKey => _vehicleKey;
  String? get regNo => _regNo;
  String? get vin => _vin;
  String? get engineNo => _engineNo;
  String? get vehicleClass => _vehicleClass;
  String? get vehicleCategory => _vehicleCategory;
  String? get make => _make;
  String? get model => _model;
  String? get fuelType => _fuelType;
  num? get mfgMonth => _mfgMonth;
  num? get mfgYear => _mfgYear;
  num? get gvw => _gvw;
  String? get speedGovSn => _speedGovSn;
  String? get ownerType => _ownerType;
  String? get activeFrom => _activeFrom;
  dynamic get activeTo => _activeTo;
  bool? get isCurrent => _isCurrent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_key'] = _vehicleKey;
    map['reg_no'] = _regNo;
    map['vin'] = _vin;
    map['engine_no'] = _engineNo;
    map['vehicle_class'] = _vehicleClass;
    map['vehicle_category'] = _vehicleCategory;
    map['make'] = _make;
    map['model'] = _model;
    map['fuel_type'] = _fuelType;
    map['mfg_month'] = _mfgMonth;
    map['mfg_year'] = _mfgYear;
    map['gvw'] = _gvw;
    map['speed_gov_sn'] = _speedGovSn;
    map['owner_type'] = _ownerType;
    map['active_from'] = _activeFrom;
    map['active_to'] = _activeTo;
    map['is_current'] = _isCurrent;
    return map;
  }

}