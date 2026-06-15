class InspectionNewQueModel {
  InspectionNewQueModel({
      bool? status, 
      String? message,
    NewInspectionData? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  InspectionNewQueModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? NewInspectionData.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  NewInspectionData? _data;
InspectionNewQueModel copyWith({  bool? status,
  String? message,
  NewInspectionData? data,
}) => InspectionNewQueModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  NewInspectionData? get data => _data;

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

class NewInspectionData {
  NewInspectionData({
      List<PreInspection>? preInspection, 
      List<UnderPitInspection>? underPitInspection, 
      List<PostInspection>? postInspection,}){
    _preInspection = preInspection;
    _underPitInspection = underPitInspection;
    _postInspection = postInspection;
}

  NewInspectionData.fromJson(dynamic json) {
    if (json['pre_inspection'] != null) {
      _preInspection = [];
      json['pre_inspection'].forEach((v) {
        _preInspection?.add(PreInspection.fromJson(v));
      });
    }
    if (json['Under Pit Inspection'] != null) {
      _underPitInspection = [];
      json['Under Pit Inspection'].forEach((v) {
        _underPitInspection?.add(UnderPitInspection.fromJson(v));
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
  List<UnderPitInspection>? _underPitInspection;
  List<PostInspection>? _postInspection;
  NewInspectionData copyWith({  List<PreInspection>? preInspection,
  List<UnderPitInspection>? underPitInspection,
  List<PostInspection>? postInspection,
}) => NewInspectionData(  preInspection: preInspection ?? _preInspection,
  underPitInspection: underPitInspection ?? _underPitInspection,
  postInspection: postInspection ?? _postInspection,
);
  List<PreInspection>? get preInspection => _preInspection;
  List<UnderPitInspection>? get underPitInspection => _underPitInspection;
  List<PostInspection>? get postInspection => _postInspection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_preInspection != null) {
      map['pre_inspection'] = _preInspection?.map((v) => v.toJson()).toList();
    }
    if (_underPitInspection != null) {
      map['Under Pit Inspection'] = _underPitInspection?.map((v) => v.toJson()).toList();
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
      String? area, 
      List<CarData>? carData,}){
    _title = title;
    _area = area;
    _carData = carData;
}

  PostInspection.fromJson(dynamic json) {
    _title = json['title'];
    _area = json['area'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarData.fromJson(v));
      });
    }
  }
  String? _title;
  String? _area;
  List<CarData>? _carData;
PostInspection copyWith({  String? title,
  String? area,
  List<CarData>? carData,
}) => PostInspection(  title: title ?? _title,
  area: area ?? _area,
  carData: carData ?? _carData,
);
  String? get title => _title;
  String? get area => _area;
  List<CarData>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['area'] = _area;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class UnderPitInspection {
  UnderPitInspection({
      String? title, 
      String? area, 
      List<CarData>? carData,}){
    _title = title;
    _area = area;
    _carData = carData;
}

  UnderPitInspection.fromJson(dynamic json) {
    _title = json['title'];
    _area = json['area'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarData.fromJson(v));
      });
    }
  }
  String? _title;
  String? _area;
  List<CarData>? _carData;
UnderPitInspection copyWith({  String? title,
  String? area,
  List<CarData>? carData,
}) => UnderPitInspection(  title: title ?? _title,
  area: area ?? _area,
  carData: carData ?? _carData,
);
  String? get title => _title;
  String? get area => _area;
  List<CarData>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['area'] = _area;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PreInspection {
  PreInspection({
      String? title, 
      String? area, 
      List<CarData>? carData,}){
    _title = title;
    _area = area;
    _carData = carData;
}

  PreInspection.fromJson(dynamic json) {
    _title = json['title'];
    _area = json['area'];
    if (json['carData'] != null) {
      _carData = [];
      json['carData'].forEach((v) {
        _carData?.add(CarData.fromJson(v));
      });
    }
  }
  String? _title;
  String? _area;
  List<CarData>? _carData;
PreInspection copyWith({  String? title,
  String? area,
  List<CarData>? carData,
}) => PreInspection(  title: title ?? _title,
  area: area ?? _area,
  carData: carData ?? _carData,
);
  String? get title => _title;
  String? get area => _area;
  List<CarData>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['area'] = _area;
    if (_carData != null) {
      map['carData'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CarData {
  CarData({
      String? title, 
      num? questionId, 
      String? questionText, 
      String? complexity, 
      List<Items>? items, 
      List<Rules>? rules, 
      dynamic aiFlag, 
      dynamic aiApiId, 
      num? allowMultiple, 
      num? photoVideo,}){
    _title = title;
    _questionId = questionId;
    _questionText = questionText;
    _complexity = complexity;
    _items = items;
    _rules = rules;
    _aiFlag = aiFlag;
    _aiApiId = aiApiId;
    _allowMultiple = allowMultiple;
    _photoVideo = photoVideo;
}

  CarData.fromJson(dynamic json) {
    _title = json['title'];
    _questionId = json['question_id'];
    _questionText = json['question_text'];
    _complexity = json['complexity'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    if (json['rules'] != null) {
      _rules = [];
      json['rules'].forEach((v) {
        _rules?.add(Rules.fromJson(v));
      });
    }
    _aiFlag = json['ai_flag'];
    _aiApiId = json['ai_api_id'];
    _allowMultiple = json['allow_multiple'];
    _photoVideo = json['photo_video'];
  }
  String? _title;
  num? _questionId;
  String? _questionText;
  String? _complexity;
  List<Items>? _items;
  List<Rules>? _rules;
  dynamic _aiFlag;
  dynamic _aiApiId;
  num? _allowMultiple;
  num? _photoVideo;
CarData copyWith({  String? title,
  num? questionId,
  String? questionText,
  String? complexity,
  List<Items>? items,
  List<Rules>? rules,
  dynamic aiFlag,
  dynamic aiApiId,
  num? allowMultiple,
  num? photoVideo,
}) => CarData(  title: title ?? _title,
  questionId: questionId ?? _questionId,
  questionText: questionText ?? _questionText,
  complexity: complexity ?? _complexity,
  items: items ?? _items,
  rules: rules ?? _rules,
  aiFlag: aiFlag ?? _aiFlag,
  aiApiId: aiApiId ?? _aiApiId,
  allowMultiple: allowMultiple ?? _allowMultiple,
  photoVideo: photoVideo ?? _photoVideo,
);
  String? get title => _title;
  num? get questionId => _questionId;
  String? get questionText => _questionText;
  String? get complexity => _complexity;
  List<Items>? get items => _items;
  List<Rules>? get rules => _rules;
  dynamic get aiFlag => _aiFlag;
  dynamic get aiApiId => _aiApiId;
  num? get allowMultiple => _allowMultiple;
  num? get photoVideo => _photoVideo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['question_id'] = _questionId;
    map['question_text'] = _questionText;
    map['complexity'] = _complexity;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    if (_rules != null) {
      map['rules'] = _rules?.map((v) => v.toJson()).toList();
    }
    map['ai_flag'] = _aiFlag;
    map['ai_api_id'] = _aiApiId;
    map['allow_multiple'] = _allowMultiple;
    map['photo_video'] = _photoVideo;
    return map;
  }

}

class Rules {
  Rules({
      num? ruleId, 
      String? ruleRef,}){
    _ruleId = ruleId;
    _ruleRef = ruleRef;
}

  Rules.fromJson(dynamic json) {
    _ruleId = json['rule_id'];
    _ruleRef = json['rule_ref'];
  }
  num? _ruleId;
  String? _ruleRef;
Rules copyWith({  num? ruleId,
  String? ruleRef,
}) => Rules(  ruleId: ruleId ?? _ruleId,
  ruleRef: ruleRef ?? _ruleRef,
);
  num? get ruleId => _ruleId;
  String? get ruleRef => _ruleRef;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rule_id'] = _ruleId;
    map['rule_ref'] = _ruleRef;
    return map;
  }

}

class Items {
  Items({
      num? itemId, 
      String? itemText,}){
    _itemId = itemId;
    _itemText = itemText;
}

  Items.fromJson(dynamic json) {
    _itemId = json['item_id'];
    _itemText = json['item_text'];
  }
  num? _itemId;
  String? _itemText;
Items copyWith({  num? itemId,
  String? itemText,
}) => Items(  itemId: itemId ?? _itemId,
  itemText: itemText ?? _itemText,
);
  num? get itemId => _itemId;
  String? get itemText => _itemText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['item_id'] = _itemId;
    map['item_text'] = _itemText;
    return map;
  }

}