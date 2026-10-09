class SaveAllResultResModel {
  SaveAllResultResModel({
      bool? success, 
      String? message,
    SaveAiData? data,
      dynamic type, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _type = type;
    _errors = errors;
}

  SaveAllResultResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'] != null ? SaveAiData.fromJson(json['Data']) : null;
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
  SaveAiData? _data;
  dynamic _type;
  List<dynamic>? _errors;
SaveAllResultResModel copyWith({  bool? success,
  String? message,
  SaveAiData? data,
  dynamic type,
  List<dynamic>? errors,
}) => SaveAllResultResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  type: type ?? _type,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  SaveAiData? get data => _data;
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

class SaveAiData {
  SaveAiData({
      num? appointmentId, 
      String? vehicleId, 
      num? status, 
      num? totalRecords, 
      num? passCount,}){
    _appointmentId = appointmentId;
    _vehicleId = vehicleId;
    _status = status;
    _totalRecords = totalRecords;
    _passCount = passCount;
}

  SaveAiData.fromJson(dynamic json) {
    _appointmentId = json['appointment_id'];
    _vehicleId = json['vehicle_id'];
    _status = json['status'];
    _totalRecords = json['total_records'];
    _passCount = json['pass_count'];
  }
  num? _appointmentId;
  String? _vehicleId;
  num? _status;
  num? _totalRecords;
  num? _passCount;
  SaveAiData copyWith({  num? appointmentId,
  String? vehicleId,
  num? status,
  num? totalRecords,
  num? passCount,
}) => SaveAiData(  appointmentId: appointmentId ?? _appointmentId,
  vehicleId: vehicleId ?? _vehicleId,
  status: status ?? _status,
  totalRecords: totalRecords ?? _totalRecords,
  passCount: passCount ?? _passCount,
);
  num? get appointmentId => _appointmentId;
  String? get vehicleId => _vehicleId;
  num? get status => _status;
  num? get totalRecords => _totalRecords;
  num? get passCount => _passCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appointment_id'] = _appointmentId;
    map['vehicle_id'] = _vehicleId;
    map['status'] = _status;
    map['total_records'] = _totalRecords;
    map['pass_count'] = _passCount;
    return map;
  }

}