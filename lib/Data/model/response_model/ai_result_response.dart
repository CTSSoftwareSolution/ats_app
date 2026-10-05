import 'package:ats_app/Domain/entities/ai_result_entity.dart';

class AiResultResponse extends AiResultEntity{
  AiResultResponse({
      bool? success, 
      String? message, 
      List<ResultData>? data,
      dynamic type, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _type = type;
    _errors = errors;
}

  AiResultResponse.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(ResultData.fromJson(v));
      });
    }
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
  List<ResultData>? _data;
  dynamic _type;
  List<dynamic>? _errors;
AiResultResponse copyWith({  bool? success,
  String? message,
  List<ResultData>? data,
  dynamic type,
  List<dynamic>? errors,
}) => AiResultResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  type: type ?? _type,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  List<ResultData>? get data => _data;
  dynamic get type => _type;
  List<dynamic>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['Type'] = _type;
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ResultData {
  ResultData({
      num? id, 
      String? vehicleId, 
      String? appointmentId, 
      num? labelId, 
      num? documentId, 
      String? questionText, 
      String? inspectionResult, 
      String? aiResult, 
      AiResponse? aiResponse,
      String? aiRemark,}){
    _id = id;
    _vehicleId = vehicleId;
    _appointmentId = appointmentId;
    _labelId = labelId;
    _documentId = documentId;
    _questionText = questionText;
    _inspectionResult = inspectionResult;
    _aiResult = aiResult;
    _aiResponse = aiResponse;
    _aiRemark = aiRemark;
}

  ResultData.fromJson(dynamic json) {
    _id = json['id'];
    _vehicleId = json['vehicle_id'];
    _appointmentId = json['appointment_id'];
    _labelId = json['label_id'];
    _documentId = json['document_id'];
    _questionText = json['question_text'];
    _inspectionResult = json['inspection_result'];
    _aiResult = json['ai_result'];
    _aiResponse = json['ai_response'] != null ? AiResponse.fromJson(json['ai_response']) : null;
    _aiRemark = json['ai_remark']?.toString();
  }
  num? _id;
  String? _vehicleId;
  String? _appointmentId;
  num? _labelId;
  num? _documentId;
  String? _questionText;
  String? _inspectionResult;
  String? _aiResult;
  AiResponse? _aiResponse;
  String? _aiRemark;
  ResultData copyWith({  num? id,
  String? vehicleId,
  String? appointmentId,
  num? labelId,
  num? documentId,
  String? questionText,
  String? inspectionResult,
  String? aiResult,
  AiResponse? aiResponse,
  String? aiRemark,
}) => ResultData(  id: id ?? _id,
  vehicleId: vehicleId ?? _vehicleId,
  appointmentId: appointmentId ?? _appointmentId,
  labelId: labelId ?? _labelId,
  documentId: documentId ?? _documentId,
  questionText: questionText ?? _questionText,
  inspectionResult: inspectionResult ?? _inspectionResult,
  aiResult: aiResult ?? _aiResult,
  aiResponse: aiResponse ?? _aiResponse,
  aiRemark: aiRemark ?? _aiRemark,
);
  num? get id => _id;
  String? get vehicleId => _vehicleId;
  String? get appointmentId => _appointmentId;
  num? get labelId => _labelId;
  num? get documentId => _documentId;
  String? get questionText => _questionText;
  String? get inspectionResult => _inspectionResult;
  String? get aiResult => _aiResult;
  AiResponse? get aiResponse => _aiResponse;
  String? get aiRemark => _aiRemark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['vehicle_id'] = _vehicleId;
    map['appointment_id'] = _appointmentId;
    map['label_id'] = _labelId;
    map['document_id'] = _documentId;
    map['question_text'] = _questionText;
    map['inspection_result'] = _inspectionResult;
    map['ai_result'] = _aiResult;
    if (_aiResponse != null) {
      map['ai_response'] = _aiResponse?.toJson();
    }
    map['ai_remark'] = _aiRemark;
    return map;
  }

}

class AiResponse {
  AiResponse({
      String? requestId, 
      bool? status, 
      String? message, 
      String? overallResult, 
      String? manualCheck, 
      dynamic analysis,}){
    _requestId = requestId;
    _status = status;
    _message = message;
    _overallResult = overallResult;
    _manualCheck = manualCheck;
    _analysis = analysis;
}

  AiResponse.fromJson(dynamic json) {
    _requestId = json['request_id'];
    _status = json['Status'];
    _message = json['message'];
    _overallResult = json['overall_result'];
    _manualCheck = json['manual_check'];
    _analysis = json['analysis'];
  }
  String? _requestId;
  bool? _status;
  String? _message;
  String? _overallResult;
  String? _manualCheck;
  dynamic _analysis;
AiResponse copyWith({  String? requestId,
  bool? status,
  String? message,
  String? overallResult,
  String? manualCheck,
  dynamic analysis,
}) => AiResponse(  requestId: requestId ?? _requestId,
  status: status ?? _status,
  message: message ?? _message,
  overallResult: overallResult ?? _overallResult,
  manualCheck: manualCheck ?? _manualCheck,
  analysis: analysis ?? _analysis,
);
  String? get requestId => _requestId;
  bool? get status => _status;
  String? get message => _message;
  String? get overallResult => _overallResult;
  String? get manualCheck => _manualCheck;
  dynamic get analysis => _analysis;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['request_id'] = _requestId;
    map['Status'] = _status;
    map['message'] = _message;
    map['overall_result'] = _overallResult;
    map['manual_check'] = _manualCheck;
    map['analysis'] = _analysis;
    return map;
  }

}