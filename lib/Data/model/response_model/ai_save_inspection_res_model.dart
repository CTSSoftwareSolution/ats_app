import '../../../Domain/entities/ai_save_inspection_entity.dart';

class AiSaveInspectionResModel extends AiSaveInspectionEntity{
  AiSaveInspectionResModel({
      bool? success, 
      String? message, 
      dynamic data, 
      List<Errors>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _errors = errors;
}

  AiSaveInspectionResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'];
    if (json['Errors'] != null) {
      _errors = [];
      json['Errors'].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
  }
  bool? _success;
  String? _message;
  dynamic _data;
  List<Errors>? _errors;
AiSaveInspectionResModel copyWith({  bool? success,
  String? message,
  dynamic data,
  List<Errors>? errors,
}) => AiSaveInspectionResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  dynamic get data => _data;
  List<Errors>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    map['Data'] = _data;
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Errors {
  Errors({
      String? field, 
      String? message,}){
    _field = field;
    _message = message;
}

  Errors.fromJson(dynamic json) {
    _field = json['Field'];
    _message = json['Message'];
  }
  String? _field;
  String? _message;
Errors copyWith({  String? field,
  String? message,
}) => Errors(  field: field ?? _field,
  message: message ?? _message,
);
  String? get field => _field;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Field'] = _field;
    map['Message'] = _message;
    return map;
  }

}