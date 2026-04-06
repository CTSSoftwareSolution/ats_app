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
      List<PostInspectionDetails>? postInspection,
      List<InspectionDetail>? inspection,
      List<PreInspectionDetail>? preInspection,}){
    _postInspection = postInspection;
    _inspection = inspection;
    _preInspection = preInspection;
}

  PreInspectionDetailsData.fromJson(dynamic json) {
    if (json['post_inspection'] != null) {
      _postInspection = [];
      json['post_inspection'].forEach((v) {
        _postInspection?.add(PostInspectionDetails.fromJson(v));
      });
    }
    if (json['inspection'] != null) {
      _inspection = [];
      json['inspection'].forEach((v) {
        _inspection?.add(InspectionDetail.fromJson(v));
      });
    }
    if (json['pre_inspection'] != null) {
      _preInspection = [];
      json['pre_inspection'].forEach((v) {
        _preInspection?.add(PreInspectionDetail.fromJson(v));
      });
    }
  }
  List<PostInspectionDetails>? _postInspection;
  List<InspectionDetail>? _inspection;
  List<PreInspectionDetail>? _preInspection;
  PreInspectionDetailsData copyWith({  List<PostInspectionDetails>? postInspection,
  List<InspectionDetail>? inspection,
  List<PreInspectionDetail>? preInspection,
}) => PreInspectionDetailsData(  postInspection: postInspection ?? _postInspection,
  inspection: inspection ?? _inspection,
  preInspection: preInspection ?? _preInspection,
);
  List<PostInspectionDetails>? get postInspection => _postInspection;
  List<InspectionDetail>? get inspection => _inspection;
  List<PreInspectionDetail>? get preInspection => _preInspection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_postInspection != null) {
      map['post_inspection'] = _postInspection?.map((v) => v.toJson()).toList();
    }
    if (_inspection != null) {
      map['inspection'] = _inspection?.map((v) => v.toJson()).toList();
    }
    if (_preInspection != null) {
      map['pre_inspection'] = _preInspection?.map((v) => v.toJson()).toList();
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

class CarDataDetails {
  CarDataDetails({
      num? questionId, 
      String? questionText, 
      String? inspectionResult, 
      String? evidenceUrl, 
      String? evidenceFileViewUrl, 
      String? remarks,}){
    _questionId = questionId;
    _questionText = questionText;
    _inspectionResult = inspectionResult;
    _evidenceUrl = evidenceUrl;
    _evidenceFileViewUrl = evidenceFileViewUrl;
    _remarks = remarks;
}

  CarDataDetails.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _questionText = json['question_text'];
    _inspectionResult = json['inspection_result'];
    _evidenceUrl = json['evidence_url'];
    _evidenceFileViewUrl = json['evidence_file_view_url'];
    _remarks = json['remarks'];
  }
  num? _questionId;
  String? _questionText;
  String? _inspectionResult;
  String? _evidenceUrl;
  String? _evidenceFileViewUrl;
  String? _remarks;
  CarDataDetails copyWith({  num? questionId,
  String? questionText,
  String? inspectionResult,
  String? evidenceUrl,
  String? evidenceFileViewUrl,
  String? remarks,
}) => CarDataDetails(  questionId: questionId ?? _questionId,
  questionText: questionText ?? _questionText,
  inspectionResult: inspectionResult ?? _inspectionResult,
  evidenceUrl: evidenceUrl ?? _evidenceUrl,
  evidenceFileViewUrl: evidenceFileViewUrl ?? _evidenceFileViewUrl,
  remarks: remarks ?? _remarks,
);
  num? get questionId => _questionId;
  String? get questionText => _questionText;
  String? get inspectionResult => _inspectionResult;
  String? get evidenceUrl => _evidenceUrl;
  String? get evidenceFileViewUrl => _evidenceFileViewUrl;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['question_text'] = _questionText;
    map['inspection_result'] = _inspectionResult;
    map['evidence_url'] = _evidenceUrl;
    map['evidence_file_view_url'] = _evidenceFileViewUrl;
    map['remarks'] = _remarks;
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
