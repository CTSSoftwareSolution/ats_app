class Model {
  Model({
      bool? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  Model.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  Data? _data;
Model copyWith({  bool? status,
  String? message,
  Data? data,
}) => Model(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

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

class Data {
  Data({
      List<Inspection>? inspection, 
      List<PreInspection>? preInspection, 
      List<PostInspection>? postInspection,}){
    _inspection = inspection;
    _preInspection = preInspection;
    _postInspection = postInspection;
}

  Data.fromJson(dynamic json) {
    if (json['inspection'] != null) {
      _inspection = [];
      json['inspection'].forEach((v) {
        _inspection?.add(Inspection.fromJson(v));
      });
    }
    if (json['pre_inspection'] != null) {
      _preInspection = [];
      json['pre_inspection'].forEach((v) {
        _preInspection?.add(PreInspection.fromJson(v));
      });
    }
    if (json['post_inspection'] != null) {
      _postInspection = [];
      json['post_inspection'].forEach((v) {
        _postInspection?.add(PostInspection.fromJson(v));
      });
    }
  }
  List<Inspection>? _inspection;
  List<PreInspection>? _preInspection;
  List<PostInspection>? _postInspection;
Data copyWith({  List<Inspection>? inspection,
  List<PreInspection>? preInspection,
  List<PostInspection>? postInspection,
}) => Data(  inspection: inspection ?? _inspection,
  preInspection: preInspection ?? _preInspection,
  postInspection: postInspection ?? _postInspection,
);
  List<Inspection>? get inspection => _inspection;
  List<PreInspection>? get preInspection => _preInspection;
  List<PostInspection>? get postInspection => _postInspection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_inspection != null) {
      map['inspection'] = _inspection?.map((v) => v.toJson()).toList();
    }
    if (_preInspection != null) {
      map['pre_inspection'] = _preInspection?.map((v) => v.toJson()).toList();
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

class CarData {
  CarData({
      num? questionId, 
      String? image, 
      String? questionText,}){
    _questionId = questionId;
    _image = image;
    _questionText = questionText;
}

  CarData.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _image = json['image'];
    _questionText = json['question_text'];
  }
  num? _questionId;
  String? _image;
  String? _questionText;
CarData copyWith({  num? questionId,
  String? image,
  String? questionText,
}) => CarData(  questionId: questionId ?? _questionId,
  image: image ?? _image,
  questionText: questionText ?? _questionText,
);
  num? get questionId => _questionId;
  String? get image => _image;
  String? get questionText => _questionText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['image'] = _image;
    map['question_text'] = _questionText;
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
