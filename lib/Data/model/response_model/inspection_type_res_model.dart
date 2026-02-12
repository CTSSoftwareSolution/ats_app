import 'package:ats_app/Domain/entities/inspection_type_entity.dart';

class InspectionTypeResModel extends InspectionTypeEntity{
  InspectionTypeResModel({
      bool? status, 
      String? message, 
      List<InspectionTypeData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  InspectionTypeResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(InspectionTypeData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<InspectionTypeData>? _data;
InspectionTypeResModel copyWith({  bool? status,
  String? message,
  List<InspectionTypeData>? data,
}) => InspectionTypeResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<InspectionTypeData>? get data => _data;

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

class InspectionTypeData {
  InspectionTypeData({
      String? inspectionTypeCode, 
      String? inspectionTypeName,}){
    _inspectionTypeCode = inspectionTypeCode;
    _inspectionTypeName = inspectionTypeName;
}

  InspectionTypeData.fromJson(dynamic json) {
    _inspectionTypeCode = json['inspection_type_code'];
    _inspectionTypeName = json['inspection_type_name'];
  }
  String? _inspectionTypeCode;
  String? _inspectionTypeName;
  InspectionTypeData copyWith({  String? inspectionTypeCode,
  String? inspectionTypeName,
}) => InspectionTypeData(  inspectionTypeCode: inspectionTypeCode ?? _inspectionTypeCode,
  inspectionTypeName: inspectionTypeName ?? _inspectionTypeName,
);
  String? get inspectionTypeCode => _inspectionTypeCode;
  String? get inspectionTypeName => _inspectionTypeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inspection_type_code'] = _inspectionTypeCode;
    map['inspection_type_name'] = _inspectionTypeName;
    return map;
  }

}