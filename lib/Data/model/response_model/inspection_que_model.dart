import '../../../Domain/entities/inspection_que_entity.dart';

class InspectionQueModel extends InspectionQueEntity{
  InspectionQueModel({
      bool? status, 
      String? message, 
      List<QuestionData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  InspectionQueModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(QuestionData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<QuestionData>? _data;
InspectionQueModel copyWith({  bool? status,
  String? message,
  List<QuestionData>? data,
}) => InspectionQueModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<QuestionData>? get data => _data;

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

class QuestionData {
  QuestionData({
      String? title, 
      List<CarData>? carData,}){
    _title = title;
    _carData = carData;
}

  QuestionData.fromJson(dynamic json) {
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
  QuestionData copyWith({  String? title,
  List<CarData>? carData,
}) => QuestionData(  title: title ?? _title,
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
      String? questionText,}){
    _questionId = questionId;
    _questionText = questionText;
}

  CarData.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _questionText = json['question_text'];
  }
  num? _questionId;
  String? _questionText;
CarData copyWith({  num? questionId,
  String? questionText,
}) => CarData(  questionId: questionId ?? _questionId,
  questionText: questionText ?? _questionText,
);
  num? get questionId => _questionId;
  String? get questionText => _questionText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['question_text'] = _questionText;
    return map;
  }

}