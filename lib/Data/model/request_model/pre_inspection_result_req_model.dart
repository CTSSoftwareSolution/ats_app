class PreInspectionResultReqModel {
  PreInspectionResultReqModel({
      String? vehicleNo, 
      String? inspectedBy, 
      List<Results>? results,}){
    _vehicleNo = vehicleNo;
    _inspectedBy = inspectedBy;
    _results = results;
}

  PreInspectionResultReqModel.fromJson(dynamic json) {
    _vehicleNo = json['vehicle_no'];
    _inspectedBy = json['inspected_by'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(Results.fromJson(v));
      });
    }
  }
  String? _vehicleNo;
  String? _inspectedBy;
  List<Results>? _results;
PreInspectionResultReqModel copyWith({  String? vehicleNo,
  String? inspectedBy,
  List<Results>? results,
}) => PreInspectionResultReqModel(  vehicleNo: vehicleNo ?? _vehicleNo,
  inspectedBy: inspectedBy ?? _inspectedBy,
  results: results ?? _results,
);
  String? get vehicleNo => _vehicleNo;
  String? get inspectedBy => _inspectedBy;
  List<Results>? get results => _results;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_no'] = _vehicleNo;
    map['inspected_by'] = _inspectedBy;
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Results {
  Results({
      num? questionId, 
      String? inspectionResult, 
      String? remarks, 
      String? severityLevel, 
      String? evidenceUrl,}){
    _questionId = questionId;
    _inspectionResult = inspectionResult;
    _remarks = remarks;
    _severityLevel = severityLevel;
    _evidenceUrl = evidenceUrl;
}

  Results.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _inspectionResult = json['inspection_result'];
    _remarks = json['remarks'];
    _severityLevel = json['severity_level'];
    _evidenceUrl = json['evidence_url'];
  }
  num? _questionId;
  String? _inspectionResult;
  String? _remarks;
  String? _severityLevel;
  String? _evidenceUrl;
Results copyWith({  num? questionId,
  String? inspectionResult,
  String? remarks,
  String? severityLevel,
  String? evidenceUrl,
}) => Results(  questionId: questionId ?? _questionId,
  inspectionResult: inspectionResult ?? _inspectionResult,
  remarks: remarks ?? _remarks,
  severityLevel: severityLevel ?? _severityLevel,
  evidenceUrl: evidenceUrl ?? _evidenceUrl,
);
  num? get questionId => _questionId;
  String? get inspectionResult => _inspectionResult;
  String? get remarks => _remarks;
  String? get severityLevel => _severityLevel;
  String? get evidenceUrl => _evidenceUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['inspection_result'] = _inspectionResult;
    map['remarks'] = _remarks;
    map['severity_level'] = _severityLevel;
    map['evidence_url'] = _evidenceUrl;
    return map;
  }

}