class AiUpdateResultReqModel {
  AiUpdateResultReqModel({
      num? appointmentId, 
      String? vehicleNo, 
      num? questionId, 
      String? aiInspectionResult, 
      String? aiRemark,}){
    _appointmentId = appointmentId;
    _vehicleNo = vehicleNo;
    _questionId = questionId;
    _aiInspectionResult = aiInspectionResult;
    _aiRemark = aiRemark;
}

  AiUpdateResultReqModel.fromJson(dynamic json) {
    _appointmentId = json['appointment_id'];
    _vehicleNo = json['vehicle_no'];
    _questionId = json['question_id'];
    _aiInspectionResult = json['ai_inspection_result'];
    _aiRemark = json['ai_remark'];
  }
  num? _appointmentId;
  String? _vehicleNo;
  num? _questionId;
  String? _aiInspectionResult;
  String? _aiRemark;
AiUpdateResultReqModel copyWith({  num? appointmentId,
  String? vehicleNo,
  num? questionId,
  String? aiInspectionResult,
  String? aiRemark,
}) => AiUpdateResultReqModel(  appointmentId: appointmentId ?? _appointmentId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  questionId: questionId ?? _questionId,
  aiInspectionResult: aiInspectionResult ?? _aiInspectionResult,
  aiRemark: aiRemark ?? _aiRemark,
);
  num? get appointmentId => _appointmentId;
  String? get vehicleNo => _vehicleNo;
  num? get questionId => _questionId;
  String? get aiInspectionResult => _aiInspectionResult;
  String? get aiRemark => _aiRemark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appointment_id'] = _appointmentId;
    map['vehicle_no'] = _vehicleNo;
    map['question_id'] = _questionId;
    map['ai_inspection_result'] = _aiInspectionResult;
    map['ai_remark'] = _aiRemark;
    return map;
  }

}