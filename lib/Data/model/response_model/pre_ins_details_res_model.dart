class PreInsDetailsResModel {
  PreInsDetailsResModel({
      bool? status, 
      String? message,
    PreInsDetailsData? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  PreInsDetailsResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? PreInsDetailsData.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  PreInsDetailsData? _data;
PreInsDetailsResModel copyWith({  bool? status,
  String? message,
  PreInsDetailsData? data,
}) => PreInsDetailsResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  PreInsDetailsData? get data => _data;

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

class PreInsDetailsData {
  PreInsDetailsData({
      List<PreInspection>? preInspection, 
      List<Inspection>? inspection, 
      List<PostInspection>? postInspection,}){
    _preInspection = preInspection;
    _inspection = inspection;
    _postInspection = postInspection;
}

  PreInsDetailsData.fromJson(dynamic json) {
    if (json['pre_inspection'] != null) {
      _preInspection = [];
      json['pre_inspection'].forEach((v) {
        _preInspection?.add(PreInspection.fromJson(v));
      });
    }
    if (json['inspection'] != null) {
      _inspection = [];
      json['inspection'].forEach((v) {
        _inspection?.add(Inspection.fromJson(v));
      });
    }
    if (json['post_inspection'] != null) {
      _postInspection = [];
      json['post_inspection'].forEach((v) {
        _postInspection?.add(PostInspection.fromJson(v));
      });
    }
  }
  List<PreInspection>? _preInspection;
  List<Inspection>? _inspection;
  List<PostInspection>? _postInspection;
  PreInsDetailsData copyWith({  List<PreInspection>? preInspection,
  List<Inspection>? inspection,
  List<PostInspection>? postInspection,
}) => PreInsDetailsData(  preInspection: preInspection ?? _preInspection,
  inspection: inspection ?? _inspection,
  postInspection: postInspection ?? _postInspection,
);
  List<PreInspection>? get preInspection => _preInspection;
  List<Inspection>? get inspection => _inspection;
  List<PostInspection>? get postInspection => _postInspection;

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

class PostInspection {
  PostInspection({
      String? title, 
      List<CarData>? carData,}){
    _title = title;
    _carData = carData;
}

  PostInspection.fromJson(dynamic json) {
    _title = json['title'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarData.fromJson(v));
      });
    }
  }
  String? _title;
  List<CarData>? _carData;
PostInspection copyWith({  String? title,
  List<CarData>? carData,
}) => PostInspection(  title: title ?? _title,
  carData: carData ?? _carData,
);
  String? get title => _title;
  List<CarData>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Inspection {
  Inspection({
      String? title, 
      List<CarData>? carData,}){
    _title = title;
    _carData = carData;
}

  Inspection.fromJson(dynamic json) {
    _title = json['title'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarData.fromJson(v));
      });
    }
  }
  String? _title;
  List<CarData>? _carData;
Inspection copyWith({  String? title,
  List<CarData>? carData,
}) => Inspection(  title: title ?? _title,
  carData: carData ?? _carData,
);
  String? get title => _title;
  List<CarData>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PreInspection {
  PreInspection({
      String? title, 
      List<CarData>? carData,}){
    _title = title;
    _carData = carData;
}

  PreInspection.fromJson(dynamic json) {
    _title = json['title'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarData.fromJson(v));
      });
    }
  }
  String? _title;
  List<CarData>? _carData;
PreInspection copyWith({  String? title,
  List<CarData>? carData,
}) => PreInspection(  title: title ?? _title,
  carData: carData ?? _carData,
);
  String? get title => _title;
  List<CarData>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CarData {
  CarData({
      num? questionId, 
      String? inspectionResult, 
      String? evidenceUrl, 
      String? questionText,}){
    _questionId = questionId;
    _inspectionResult = inspectionResult;
    _evidenceUrl = evidenceUrl;
    _questionText = questionText;
}

  CarData.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _inspectionResult = json['inspection_result'];
    _evidenceUrl = json['evidence_url'];
    _questionText = json['question_text'];
  }
  num? _questionId;
  String? _inspectionResult;
  String? _evidenceUrl;
  String? _questionText;
CarData copyWith({  num? questionId,
  String? inspectionResult,
  String? evidenceUrl,
  String? questionText,
}) => CarData(  questionId: questionId ?? _questionId,
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