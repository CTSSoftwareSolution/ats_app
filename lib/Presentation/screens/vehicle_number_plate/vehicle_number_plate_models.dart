class VehicleNumberPlateModels {
  VehicleNumberPlateModels({
      bool? status, 
      String? requestId, 
      String? analysisMsg, 
      Analysis? analysis,}){
    _status = status;
    _requestId = requestId;
    _analysisMsg = analysisMsg;
    _analysis = analysis;
}

  VehicleNumberPlateModels.fromJson(dynamic json) {
    _status = json['status'];
    _requestId = json['request_id'];
    _analysisMsg = json['analysisMsg'];
    _analysis = json['analysis'] != null ? Analysis.fromJson(json['analysis']) : null;
  }
  bool? _status;
  String? _requestId;
  String? _analysisMsg;
  Analysis? _analysis;
VehicleNumberPlateModels copyWith({  bool? status,
  String? requestId,
  String? analysisMsg,
  Analysis? analysis,
}) => VehicleNumberPlateModels(  status: status ?? _status,
  requestId: requestId ?? _requestId,
  analysisMsg: analysisMsg ?? _analysisMsg,
  analysis: analysis ?? _analysis,
);
  bool? get status => _status;
  String? get requestId => _requestId;
  String? get analysisMsg => _analysisMsg;
  Analysis? get analysis => _analysis;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['request_id'] = _requestId;
    map['analysisMsg'] = _analysisMsg;
    if (_analysis != null) {
      map['analysis'] = _analysis?.toJson();
    }
    return map;
  }

}

class Analysis {
  Analysis({
      String? requestId, 
      String? timestamp, 
      bool? platePresence, 
      bool? symbolPresent, 
      bool? laserIdPresent, 
      String? expectedPlate, 
      String? ocrPlateText, 
      num? score, 
      String? decision, 
      String? reason,}){
    _requestId = requestId;
    _timestamp = timestamp;
    _platePresence = platePresence;
    _symbolPresent = symbolPresent;
    _laserIdPresent = laserIdPresent;
    _expectedPlate = expectedPlate;
    _ocrPlateText = ocrPlateText;
    _score = score;
    _decision = decision;
    _reason = reason;
}

  Analysis.fromJson(dynamic json) {
    _requestId = json['request_id'];
    _timestamp = json['timestamp'];
    _platePresence = json['plate_presence'];
    _symbolPresent = json['symbol_present'];
    _laserIdPresent = json['laser_id_present'];
    _expectedPlate = json['expected_plate'];
    _ocrPlateText = json['ocr_plate_text'];
    _score = json['score'];
    _decision = json['decision'];
    _reason = json['reason'];
  }
  String? _requestId;
  String? _timestamp;
  bool? _platePresence;
  bool? _symbolPresent;
  bool? _laserIdPresent;
  String? _expectedPlate;
  String? _ocrPlateText;
  num? _score;
  String? _decision;
  String? _reason;
Analysis copyWith({  String? requestId,
  String? timestamp,
  bool? platePresence,
  bool? symbolPresent,
  bool? laserIdPresent,
  String? expectedPlate,
  String? ocrPlateText,
  num? score,
  String? decision,
  String? reason,
}) => Analysis(  requestId: requestId ?? _requestId,
  timestamp: timestamp ?? _timestamp,
  platePresence: platePresence ?? _platePresence,
  symbolPresent: symbolPresent ?? _symbolPresent,
  laserIdPresent: laserIdPresent ?? _laserIdPresent,
  expectedPlate: expectedPlate ?? _expectedPlate,
  ocrPlateText: ocrPlateText ?? _ocrPlateText,
  score: score ?? _score,
  decision: decision ?? _decision,
  reason: reason ?? _reason,
);
  String? get requestId => _requestId;
  String? get timestamp => _timestamp;
  bool? get platePresence => _platePresence;
  bool? get symbolPresent => _symbolPresent;
  bool? get laserIdPresent => _laserIdPresent;
  String? get expectedPlate => _expectedPlate;
  String? get ocrPlateText => _ocrPlateText;
  num? get score => _score;
  String? get decision => _decision;
  String? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['request_id'] = _requestId;
    map['timestamp'] = _timestamp;
    map['plate_presence'] = _platePresence;
    map['symbol_present'] = _symbolPresent;
    map['laser_id_present'] = _laserIdPresent;
    map['expected_plate'] = _expectedPlate;
    map['ocr_plate_text'] = _ocrPlateText;
    map['score'] = _score;
    map['decision'] = _decision;
    map['reason'] = _reason;
    return map;
  }

}