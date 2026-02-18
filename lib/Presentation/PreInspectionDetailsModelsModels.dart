class PreInspectionDetailsModelsModels {
  PreInspectionDetailsModelsModels({
      bool? status, 
      String? message,
    PreInspectionDetailsData? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  PreInspectionDetailsModelsModels.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? PreInspectionDetailsData.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  PreInspectionDetailsData? _data;
PreInspectionDetailsModelsModels copyWith({  bool? status,
  String? message,
  PreInspectionDetailsData? data,
}) => PreInspectionDetailsModelsModels(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  PreInspectionDetailsData? get data => _data;

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

class PreInspectionDetailsData {
  PreInspectionDetailsData({
      List<PreInspectionDetail>? preInspection,
      List<InspectionDetail>? inspection,
      List<PostInspectionDetails>? postInspection,}){
    _preInspection = preInspection;
    _inspection = inspection;
    _postInspection = postInspection;
}

  PreInspectionDetailsData.fromJson(dynamic json) {
    if (json['pre_inspection'] != null) {
      _preInspection = [];
      json['pre_inspection'].forEach((v) {
        _preInspection?.add(PreInspectionDetail.fromJson(v));
      });
    }
    if (json['inspection'] != null) {
      _inspection = [];
      json['inspection'].forEach((v) {
        _inspection?.add(InspectionDetail.fromJson(v));
      });
    }
    if (json['post_inspection'] != null) {
      _postInspection = [];
      json['post_inspection'].forEach((v) {
        _postInspection?.add(PostInspectionDetails.fromJson(v));
      });
    }
  }
  List<PreInspectionDetail>? _preInspection;
  List<InspectionDetail>? _inspection;
  List<PostInspectionDetails>? _postInspection;
  PreInspectionDetailsData copyWith({  List<PreInspectionDetail>? preInspection,
  List<InspectionDetail>? inspection,
  List<PostInspectionDetails>? postInspection,
}) => PreInspectionDetailsData(  preInspection: preInspection ?? _preInspection,
  inspection: inspection ?? _inspection,
  postInspection: postInspection ?? _postInspection,
);
  List<PreInspectionDetail>? get preInspection => _preInspection;
  List<InspectionDetail>? get inspection => _inspection;
  List<PostInspectionDetails>? get postInspection => _postInspection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_preInspection != null) {
      map['pre_inspection'] = _preInspection?.map((v) => v.toJson()).toList();
    }
    if (_inspection != null) {
      map['inspection'] = _inspection?.map((v) => v.toJson()).toList();
    }
    if (_postInspection != null) {
      map['post_inspection'] = _postInspection?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PostInspectionDetails {
  PostInspectionDetails({
      String? title, 
      List<CarDataDetails>? carData,}){
    _title = title;
    _carData = carData;
}

  PostInspectionDetails.fromJson(dynamic json) {
    _title = json['title'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarDataDetails.fromJson(v));
      });
    }
  }
  String? _title;
  List<CarDataDetails>? _carData;
  PostInspectionDetails copyWith({  String? title,
  List<CarDataDetails>? carData,
}) => PostInspectionDetails(  title: title ?? _title,
  carData: carData ?? _carData,
);
  String? get title => _title;
  List<CarDataDetails>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CarDataDetails {
  CarDataDetails({
      num? questionId, 
      String? inspectionResult, 
      String? evidenceUrl, 
      String? questionText,}){
    _questionId = questionId;
    _inspectionResult = inspectionResult;
    _evidenceUrl = evidenceUrl;
    _questionText = questionText;
}

  CarDataDetails.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _inspectionResult = json['inspection_result'];
    _evidenceUrl = json['evidence_url'];
    _questionText = json['question_text'];
  }
  num? _questionId;
  String? _inspectionResult;
  String? _evidenceUrl;
  String? _questionText;
  CarDataDetails copyWith({  num? questionId,
  String? inspectionResult,
  String? evidenceUrl,
  String? questionText,
}) => CarDataDetails(  questionId: questionId ?? _questionId,
  inspectionResult: inspectionResult ?? _inspectionResult,
  evidenceUrl: evidenceUrl ?? _evidenceUrl,
  questionText: questionText ?? _questionText,
);
  num? get questionId => _questionId;
  String? get inspectionResult => _inspectionResult;
  String? get evidenceUrl => _evidenceUrl;
  String? get questionText => _questionText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['inspection_result'] = _inspectionResult;
    map['evidence_url'] = _evidenceUrl;
    map['question_text'] = _questionText;
    return map;
  }

}

class InspectionDetail {
  InspectionDetail({
      String? title, 
      List<CarDataDetails>? carData,}){
    _title = title;
    _carData = carData;
}

  InspectionDetail.fromJson(dynamic json) {
    _title = json['title'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarDataDetails.fromJson(v));
      });
    }
  }
  String? _title;
  List<CarDataDetails>? _carData;
  InspectionDetail copyWith({  String? title,
  List<CarDataDetails>? carData,
}) => InspectionDetail(  title: title ?? _title,
  carData: carData ?? _carData,
);
  String? get title => _title;
  List<CarDataDetails>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class PreInspectionDetail {
  PreInspectionDetail({
      String? title, 
      List<CarDataDetails>? carData,}){
    _title = title;
    _carData = carData;
}

  PreInspectionDetail.fromJson(dynamic json) {
    _title = json['title'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarDataDetails.fromJson(v));
      });
    }
  }
  String? _title;
  List<CarDataDetails>? _carData;
  PreInspectionDetail copyWith({  String? title,
  List<CarDataDetails>? carData,
}) => PreInspectionDetail(  title: title ?? _title,
  carData: carData ?? _carData,
);
  String? get title => _title;
  List<CarDataDetails>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CarDataDetail {
  CarDataDetail({
      num? questionId, 
      String? inspectionResult, 
      dynamic evidenceUrl, 
      String? questionText,}){
    _questionId = questionId;
    _inspectionResult = inspectionResult;
    _evidenceUrl = evidenceUrl;
    _questionText = questionText;
}

  CarDataDetail.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _inspectionResult = json['inspection_result'];
    _evidenceUrl = json['evidence_url'];
    _questionText = json['question_text'];
  }
  num? _questionId;
  String? _inspectionResult;
  dynamic _evidenceUrl;
  String? _questionText;
  CarDataDetails copyWith({  num? questionId,
  String? inspectionResult,
  dynamic evidenceUrl,
  String? questionText,
}) => CarDataDetails(  questionId: questionId ?? _questionId,
  inspectionResult: inspectionResult ?? _inspectionResult,
  evidenceUrl: evidenceUrl ?? _evidenceUrl,
  questionText: questionText ?? _questionText,
);
  num? get questionId => _questionId;
  String? get inspectionResult => _inspectionResult;
  dynamic get evidenceUrl => _evidenceUrl;
  String? get questionText => _questionText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['inspection_result'] = _inspectionResult;
    map['evidence_url'] = _evidenceUrl;
    map['question_text'] = _questionText;
    return map;
  }

}