class ManualInspectionListModel {
  ManualInspectionListModel({
      bool? status, 
      String? message,
    ManualInsData? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ManualInspectionListModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? ManualInsData.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  ManualInsData? _data;
ManualInspectionListModel copyWith({  bool? status,
  String? message,
  ManualInsData? data,
}) => ManualInspectionListModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  ManualInsData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

class ManualInsData {
  ManualInsData({
      num? totalRecords, 
      num? pageNo, 
      num? pageSize, 
      List<Appointments>? appointments,}){
    _totalRecords = totalRecords;
    _pageNo = pageNo;
    _pageSize = pageSize;
    _appointments = appointments;
}

  ManualInsData.fromJson(dynamic json) {
    _totalRecords = json['total_records'];
    _pageNo = json['page_no'];
    _pageSize = json['page_size'];
    if (json['appointments'] != null) {
      _appointments = [];
      json['appointments'].forEach((v) {
        _appointments?.add(Appointments.fromJson(v));
      });
    }
  }
  num? _totalRecords;
  num? _pageNo;
  num? _pageSize;
  List<Appointments>? _appointments;
  ManualInsData copyWith({  num? totalRecords,
  num? pageNo,
  num? pageSize,
  List<Appointments>? appointments,
}) => ManualInsData(  totalRecords: totalRecords ?? _totalRecords,
  pageNo: pageNo ?? _pageNo,
  pageSize: pageSize ?? _pageSize,
  appointments: appointments ?? _appointments,
);
  num? get totalRecords => _totalRecords;
  num? get pageNo => _pageNo;
  num? get pageSize => _pageSize;
  List<Appointments>? get appointments => _appointments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_records'] = _totalRecords;
    map['page_no'] = _pageNo;
    map['page_size'] = _pageSize;
    if (_appointments != null) {
      map['appointments'] = _appointments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Appointments {
  Appointments({
      String? vehicleKey, 
      num? appointmentId, 
      String? registrationNo, 
      num? status, 
      String? vehicleClass, 
      String? vehicleCategory, 
      String? fuelType, 
      String? ownerType, 
      String? activeFrom, 
      bool? speedGovSn, 
      String? vin, 
      String? mfgYear, 
      String? isCurrent, 
      String? activeTo, 
      String? manualPreInspectionStatus, 
      String? machineInspectonStatus, 
      String? engineNo, 
      String? make, 
      String? model, 
      String? mfgMonth, 
      num? gvw, 
      String? manualStatus,}){
    _vehicleKey = vehicleKey;
    _appointmentId = appointmentId;
    _registrationNo = registrationNo;
    _status = status;
    _vehicleClass = vehicleClass;
    _vehicleCategory = vehicleCategory;
    _fuelType = fuelType;
    _ownerType = ownerType;
    _activeFrom = activeFrom;
    _speedGovSn = speedGovSn;
    _vin = vin;
    _mfgYear = mfgYear;
    _isCurrent = isCurrent;
    _activeTo = activeTo;
    _manualPreInspectionStatus = manualPreInspectionStatus;
    _machineInspectonStatus = machineInspectonStatus;
    _engineNo = engineNo;
    _make = make;
    _model = model;
    _mfgMonth = mfgMonth;
    _gvw = gvw;
    _manualStatus = manualStatus;
}

  Appointments.fromJson(dynamic json) {
    _vehicleKey = json['vehicle_key'];
    _appointmentId = json['appointment_id'];
    _registrationNo = json['registration_no'];
    _status = json['status'];
    _vehicleClass = json['vehicle_class'];
    _vehicleCategory = json['vehicle_category'];
    _fuelType = json['fuel_type'];
    _ownerType = json['owner_type'];
    _activeFrom = json['active_from'];
    _speedGovSn = json['speed_gov_sn'];
    _vin = json['vin'];
    _mfgYear = json['mfg_year'];
    _isCurrent = json['is_current'];
    _activeTo = json['active_to'];
    _manualPreInspectionStatus = json['manual_pre_inspection_status'];
    _machineInspectonStatus = json['machine_inspecton_status'];
    _engineNo = json['engine_no'];
    _make = json['make'];
    _model = json['model'];
    _mfgMonth = json['mfg_month'];
    _gvw = json['gvw'];
    _manualStatus = json['manual_status'];
  }
  String? _vehicleKey;
  num? _appointmentId;
  String? _registrationNo;
  num? _status;
  String? _vehicleClass;
  String? _vehicleCategory;
  String? _fuelType;
  String? _ownerType;
  String? _activeFrom;
  bool? _speedGovSn;
  String? _vin;
  String? _mfgYear;
  String? _isCurrent;
  String? _activeTo;
  String? _manualPreInspectionStatus;
  String? _machineInspectonStatus;
  String? _engineNo;
  String? _make;
  String? _model;
  String? _mfgMonth;
  num? _gvw;
  String? _manualStatus;
Appointments copyWith({  String? vehicleKey,
  num? appointmentId,
  String? registrationNo,
  num? status,
  String? vehicleClass,
  String? vehicleCategory,
  String? fuelType,
  String? ownerType,
  String? activeFrom,
  bool? speedGovSn,
  String? vin,
  String? mfgYear,
  String? isCurrent,
  String? activeTo,
  String? manualPreInspectionStatus,
  String? machineInspectonStatus,
  String? engineNo,
  String? make,
  String? model,
  String? mfgMonth,
  num? gvw,
  String? manualStatus,
}) => Appointments(  vehicleKey: vehicleKey ?? _vehicleKey,
  appointmentId: appointmentId ?? _appointmentId,
  registrationNo: registrationNo ?? _registrationNo,
  status: status ?? _status,
  vehicleClass: vehicleClass ?? _vehicleClass,
  vehicleCategory: vehicleCategory ?? _vehicleCategory,
  fuelType: fuelType ?? _fuelType,
  ownerType: ownerType ?? _ownerType,
  activeFrom: activeFrom ?? _activeFrom,
  speedGovSn: speedGovSn ?? _speedGovSn,
  vin: vin ?? _vin,
  mfgYear: mfgYear ?? _mfgYear,
  isCurrent: isCurrent ?? _isCurrent,
  activeTo: activeTo ?? _activeTo,
  manualPreInspectionStatus: manualPreInspectionStatus ?? _manualPreInspectionStatus,
  machineInspectonStatus: machineInspectonStatus ?? _machineInspectonStatus,
  engineNo: engineNo ?? _engineNo,
  make: make ?? _make,
  model: model ?? _model,
  mfgMonth: mfgMonth ?? _mfgMonth,
  gvw: gvw ?? _gvw,
  manualStatus: manualStatus ?? _manualStatus,
);
  String? get vehicleKey => _vehicleKey;
  num? get appointmentId => _appointmentId;
  String? get registrationNo => _registrationNo;
  num? get status => _status;
  String? get vehicleClass => _vehicleClass;
  String? get vehicleCategory => _vehicleCategory;
  String? get fuelType => _fuelType;
  String? get ownerType => _ownerType;
  String? get activeFrom => _activeFrom;
  bool? get speedGovSn => _speedGovSn;
  String? get vin => _vin;
  String? get mfgYear => _mfgYear;
  String? get isCurrent => _isCurrent;
  String? get activeTo => _activeTo;
  String? get manualPreInspectionStatus => _manualPreInspectionStatus;
  String? get machineInspectonStatus => _machineInspectonStatus;
  String? get engineNo => _engineNo;
  String? get make => _make;
  String? get model => _model;
  String? get mfgMonth => _mfgMonth;
  num? get gvw => _gvw;
  String? get manualStatus => _manualStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_key'] = _vehicleKey;
    map['appointment_id'] = _appointmentId;
    map['registration_no'] = _registrationNo;
    map['status'] = _status;
    map['vehicle_class'] = _vehicleClass;
    map['vehicle_category'] = _vehicleCategory;
    map['fuel_type'] = _fuelType;
    map['owner_type'] = _ownerType;
    map['active_from'] = _activeFrom;
    map['speed_gov_sn'] = _speedGovSn;
    map['vin'] = _vin;
    map['mfg_year'] = _mfgYear;
    map['is_current'] = _isCurrent;
    map['active_to'] = _activeTo;
    map['manual_pre_inspection_status'] = _manualPreInspectionStatus;
    map['machine_inspecton_status'] = _machineInspectonStatus;
    map['engine_no'] = _engineNo;
    map['make'] = _make;
    map['model'] = _model;
    map['mfg_month'] = _mfgMonth;
    map['gvw'] = _gvw;
    map['manual_status'] = _manualStatus;
    return map;
  }

}