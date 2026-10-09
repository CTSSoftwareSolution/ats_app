import 'package:ats_app/Domain/entities/ai_inspection_list_entity.dart';

class AiInspectionListResModel extends AiInspectionListEntity{
  AiInspectionListResModel({
      bool? status, 
      String? message,
    AiInspectionListData? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  AiInspectionListResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? AiInspectionListData.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  AiInspectionListData? _data;
AiInspectionListResModel copyWith({  bool? status,
  String? message,
  AiInspectionListData? data,
}) => AiInspectionListResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  AiInspectionListData? get data => _data;

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

class AiInspectionListData {
  AiInspectionListData({
      num? totalRecords, 
      num? pageNo, 
      num? pageSize, 
      List<Appointments>? appointments,}){
    _totalRecords = totalRecords;
    _pageNo = pageNo;
    _pageSize = pageSize;
    _appointments = appointments;
}

  AiInspectionListData.fromJson(dynamic json) {
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
  AiInspectionListData copyWith({  num? totalRecords,
  num? pageNo,
  num? pageSize,
  List<Appointments>? appointments,
}) => AiInspectionListData(  totalRecords: totalRecords ?? _totalRecords,
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
      num? appointmentId, 
      String? registrationNo, 
      String? bookingId, 
      num? status, 
      String? statusName, 
      String? statusLabel, 
      num? laneId, 
      String? laneName, 
      String? appointmentDate, 
      String? make, 
      String? model, 
      String? customerName, 
      num? aiPassCount, 
      num? aiFailCount,}){
    _appointmentId = appointmentId;
    _registrationNo = registrationNo;
    _bookingId = bookingId;
    _status = status;
    _statusName = statusName;
    _statusLabel = statusLabel;
    _laneId = laneId;
    _laneName = laneName;
    _appointmentDate = appointmentDate;
    _make = make;
    _model = model;
    _customerName = customerName;
    _aiPassCount = aiPassCount;
    _aiFailCount = aiFailCount;
}

  Appointments.fromJson(dynamic json) {
    _appointmentId = json['appointment_id'];
    _registrationNo = json['registration_no'];
    _bookingId = json['booking_id'];
    _status = json['status'];
    _statusName = json['status_name'];
    _statusLabel = json['status_label'];
    _laneId = json['lane_id'];
    _laneName = json['lane_name'];
    _appointmentDate = json['appointment_date'];
    _make = json['make'];
    _model = json['model'];
    _customerName = json['customer_name'];
    _aiPassCount = json['ai_pass_count'];
    _aiFailCount = json['ai_fail_count'];
  }
  num? _appointmentId;
  String? _registrationNo;
  String? _bookingId;
  num? _status;
  String? _statusName;
  String? _statusLabel;
  num? _laneId;
  String? _laneName;
  String? _appointmentDate;
  String? _make;
  String? _model;
  String? _customerName;
  num? _aiPassCount;
  num? _aiFailCount;
Appointments copyWith({  num? appointmentId,
  String? registrationNo,
  String? bookingId,
  num? status,
  String? statusName,
  String? statusLabel,
  num? laneId,
  String? laneName,
  String? appointmentDate,
  String? make,
  String? model,
  String? customerName,
  num? aiPassCount,
  num? aiFailCount,
}) => Appointments(  appointmentId: appointmentId ?? _appointmentId,
  registrationNo: registrationNo ?? _registrationNo,
  bookingId: bookingId ?? _bookingId,
  status: status ?? _status,
  statusName: statusName ?? _statusName,
  statusLabel: statusLabel ?? _statusLabel,
  laneId: laneId ?? _laneId,
  laneName: laneName ?? _laneName,
  appointmentDate: appointmentDate ?? _appointmentDate,
  make: make ?? _make,
  model: model ?? _model,
  customerName: customerName ?? _customerName,
  aiPassCount: aiPassCount ?? _aiPassCount,
  aiFailCount: aiFailCount ?? _aiFailCount,
);
  num? get appointmentId => _appointmentId;
  String? get registrationNo => _registrationNo;
  String? get bookingId => _bookingId;
  num? get status => _status;
  String? get statusName => _statusName;
  String? get statusLabel => _statusLabel;
  num? get laneId => _laneId;
  String? get laneName => _laneName;
  String? get appointmentDate => _appointmentDate;
  String? get make => _make;
  String? get model => _model;
  String? get customerName => _customerName;
  num? get aiPassCount => _aiPassCount;
  num? get aiFailCount => _aiFailCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appointment_id'] = _appointmentId;
    map['registration_no'] = _registrationNo;
    map['booking_id'] = _bookingId;
    map['status'] = _status;
    map['status_name'] = _statusName;
    map['status_label'] = _statusLabel;
    map['lane_id'] = _laneId;
    map['lane_name'] = _laneName;
    map['appointment_date'] = _appointmentDate;
    map['make'] = _make;
    map['model'] = _model;
    map['customer_name'] = _customerName;
    map['ai_pass_count'] = _aiPassCount;
    map['ai_fail_count'] = _aiFailCount;
    return map;
  }

}