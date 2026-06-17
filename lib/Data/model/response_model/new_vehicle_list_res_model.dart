class NewVehicleListResModel {
  NewVehicleListResModel({
      bool? success, 
      String? message,
    NewVehicleListData? data,
      dynamic type, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _type = type;
    _errors = errors;
}

  NewVehicleListResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'] != null ? NewVehicleListData.fromJson(json['Data']) : null;
    _type = json['Type'];
    if (json['Errors'] != null) {
      _errors = [];
      // json['Errors'].forEach((v) {
      //   _errors?.add(Dynamic.fromJson(v));
      // });
    }
  }
  bool? _success;
  String? _message;
  NewVehicleListData? _data;
  dynamic _type;
  List<dynamic>? _errors;
NewVehicleListResModel copyWith({  bool? success,
  String? message,
  NewVehicleListData? data,
  dynamic type,
  List<dynamic>? errors,
}) => NewVehicleListResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  type: type ?? _type,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  NewVehicleListData? get data => _data;
  dynamic get type => _type;
  List<dynamic>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    map['Type'] = _type;
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class NewVehicleListData {
  NewVehicleListData({
      num? total, 
      num? pageNo, 
      num? pageSize, 
      List<Rows>? rows,}){
    _total = total;
    _pageNo = pageNo;
    _pageSize = pageSize;
    _rows = rows;
}

  NewVehicleListData.fromJson(dynamic json) {
    _total = json['total'];
    _pageNo = json['page_no'];
    _pageSize = json['page_size'];
    if (json['rows'] != null) {
      _rows = [];
      json['rows'].forEach((v) {
        _rows?.add(Rows.fromJson(v));
      });
    }
  }
  num? _total;
  num? _pageNo;
  num? _pageSize;
  List<Rows>? _rows;
  NewVehicleListData copyWith({  num? total,
  num? pageNo,
  num? pageSize,
  List<Rows>? rows,
}) => NewVehicleListData(  total: total ?? _total,
  pageNo: pageNo ?? _pageNo,
  pageSize: pageSize ?? _pageSize,
  rows: rows ?? _rows,
);
  num? get total => _total;
  num? get pageNo => _pageNo;
  num? get pageSize => _pageSize;
  List<Rows>? get rows => _rows;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    map['page_no'] = _pageNo;
    map['page_size'] = _pageSize;
    if (_rows != null) {
      map['rows'] = _rows?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Rows {
  Rows({
      num? appointmentId, 
      String? bookingId, 
      String? registrationNo, 
      String? customerName, 
      String? customerContact, 
      num? categoryType, 
      String? categoryName, 
      num? fuelType, 
      String? fuelTypeName, 
      num? subCategory, 
      String? fitnessExpiry, 
      num? statusId, 
      String? statusName, 
      num? laneId, 
      String? laneName, 
      num? laneTypeId, 
      String? laneTypeName, 
      String? laneTypeCode, 
      String? make, 
      String? model, 
      String? registrationValidity, 
      dynamic finalResult,}){
    _appointmentId = appointmentId;
    _bookingId = bookingId;
    _registrationNo = registrationNo;
    _customerName = customerName;
    _customerContact = customerContact;
    _categoryType = categoryType;
    _categoryName = categoryName;
    _fuelType = fuelType;
    _fuelTypeName = fuelTypeName;
    _subCategory = subCategory;
    _fitnessExpiry = fitnessExpiry;
    _statusId = statusId;
    _statusName = statusName;
    _laneId = laneId;
    _laneName = laneName;
    _laneTypeId = laneTypeId;
    _laneTypeName = laneTypeName;
    _laneTypeCode = laneTypeCode;
    _make = make;
    _model = model;
    _registrationValidity = registrationValidity;
    _finalResult = finalResult;
}

  Rows.fromJson(dynamic json) {
    _appointmentId = json['appointment_id'];
    _bookingId = json['booking_id'];
    _registrationNo = json['registration_no'];
    _customerName = json['customer_name'];
    _customerContact = json['customer_contact'];
    _categoryType = json['category_type'];
    _categoryName = json['category_name'];
    _fuelType = json['fuel_type'];
    _fuelTypeName = json['fuel_type_name'];
    _subCategory = json['sub_category'];
    _fitnessExpiry = json['fitness_expiry'];
    _statusId = json['status_id'];
    _statusName = json['status_name'];
    _laneId = json['lane_id'];
    _laneName = json['lane_name'];
    _laneTypeId = json['lane_type_id'];
    _laneTypeName = json['lane_type_name'];
    _laneTypeCode = json['lane_type_code'];
    _make = json['make'];
    _model = json['model'];
    _registrationValidity = json['registration_validity'];
    _finalResult = json['final_result'];
  }
  num? _appointmentId;
  String? _bookingId;
  String? _registrationNo;
  String? _customerName;
  String? _customerContact;
  num? _categoryType;
  String? _categoryName;
  num? _fuelType;
  String? _fuelTypeName;
  num? _subCategory;
  String? _fitnessExpiry;
  num? _statusId;
  String? _statusName;
  num? _laneId;
  String? _laneName;
  num? _laneTypeId;
  String? _laneTypeName;
  String? _laneTypeCode;
  String? _make;
  String? _model;
  String? _registrationValidity;
  dynamic _finalResult;
Rows copyWith({  num? appointmentId,
  String? bookingId,
  String? registrationNo,
  String? customerName,
  String? customerContact,
  num? categoryType,
  String? categoryName,
  num? fuelType,
  String? fuelTypeName,
  num? subCategory,
  String? fitnessExpiry,
  num? statusId,
  String? statusName,
  num? laneId,
  String? laneName,
  num? laneTypeId,
  String? laneTypeName,
  String? laneTypeCode,
  String? make,
  String? model,
  String? registrationValidity,
  dynamic finalResult,
}) => Rows(  appointmentId: appointmentId ?? _appointmentId,
  bookingId: bookingId ?? _bookingId,
  registrationNo: registrationNo ?? _registrationNo,
  customerName: customerName ?? _customerName,
  customerContact: customerContact ?? _customerContact,
  categoryType: categoryType ?? _categoryType,
  categoryName: categoryName ?? _categoryName,
  fuelType: fuelType ?? _fuelType,
  fuelTypeName: fuelTypeName ?? _fuelTypeName,
  subCategory: subCategory ?? _subCategory,
  fitnessExpiry: fitnessExpiry ?? _fitnessExpiry,
  statusId: statusId ?? _statusId,
  statusName: statusName ?? _statusName,
  laneId: laneId ?? _laneId,
  laneName: laneName ?? _laneName,
  laneTypeId: laneTypeId ?? _laneTypeId,
  laneTypeName: laneTypeName ?? _laneTypeName,
  laneTypeCode: laneTypeCode ?? _laneTypeCode,
  make: make ?? _make,
  model: model ?? _model,
  registrationValidity: registrationValidity ?? _registrationValidity,
  finalResult: finalResult ?? _finalResult,
);
  num? get appointmentId => _appointmentId;
  String? get bookingId => _bookingId;
  String? get registrationNo => _registrationNo;
  String? get customerName => _customerName;
  String? get customerContact => _customerContact;
  num? get categoryType => _categoryType;
  String? get categoryName => _categoryName;
  num? get fuelType => _fuelType;
  String? get fuelTypeName => _fuelTypeName;
  num? get subCategory => _subCategory;
  String? get fitnessExpiry => _fitnessExpiry;
  num? get statusId => _statusId;
  String? get statusName => _statusName;
  num? get laneId => _laneId;
  String? get laneName => _laneName;
  num? get laneTypeId => _laneTypeId;
  String? get laneTypeName => _laneTypeName;
  String? get laneTypeCode => _laneTypeCode;
  String? get make => _make;
  String? get model => _model;
  String? get registrationValidity => _registrationValidity;
  dynamic get finalResult => _finalResult;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appointment_id'] = _appointmentId;
    map['booking_id'] = _bookingId;
    map['registration_no'] = _registrationNo;
    map['customer_name'] = _customerName;
    map['customer_contact'] = _customerContact;
    map['category_type'] = _categoryType;
    map['category_name'] = _categoryName;
    map['fuel_type'] = _fuelType;
    map['fuel_type_name'] = _fuelTypeName;
    map['sub_category'] = _subCategory;
    map['fitness_expiry'] = _fitnessExpiry;
    map['status_id'] = _statusId;
    map['status_name'] = _statusName;
    map['lane_id'] = _laneId;
    map['lane_name'] = _laneName;
    map['lane_type_id'] = _laneTypeId;
    map['lane_type_name'] = _laneTypeName;
    map['lane_type_code'] = _laneTypeCode;
    map['make'] = _make;
    map['model'] = _model;
    map['registration_validity'] = _registrationValidity;
    map['final_result'] = _finalResult;
    return map;
  }

}