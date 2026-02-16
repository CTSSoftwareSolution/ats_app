import 'package:ats_app/Domain/entities/pre_ins_details_entity.dart';

class PreInsDetailsResModel extends PreInsDetailsEntity{
  PreInsDetailsResModel({
      bool? status, 
      String? message, 
      List<PreInsDetailsData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  PreInsDetailsResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(PreInsDetailsData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<PreInsDetailsData>? _data;
PreInsDetailsResModel copyWith({  bool? status,
  String? message,
  List<PreInsDetailsData>? data,
}) => PreInsDetailsResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<PreInsDetailsData>? get data => _data;

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

class PreInsDetailsData {
  PreInsDetailsData({
      num? questionId, 
      String? questionText, 
      String? inspectionResult,}){
    _questionId = questionId;
    _questionText = questionText;
    _inspectionResult = inspectionResult;
}

  PreInsDetailsData.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _questionText = json['question_text'];
    _inspectionResult = json['inspection_result'];
  }
  num? _questionId;
  String? _questionText;
  String? _inspectionResult;
  PreInsDetailsData copyWith({  num? questionId,
  String? questionText,
  String? inspectionResult,
}) => PreInsDetailsData(  questionId: questionId ?? _questionId,
  questionText: questionText ?? _questionText,
  inspectionResult: inspectionResult ?? _inspectionResult,
);
  num? get questionId => _questionId;
  String? get questionText => _questionText;
  String? get inspectionResult => _inspectionResult;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['question_text'] = _questionText;
    map['inspection_result'] = _inspectionResult;
    return map;
  }

}