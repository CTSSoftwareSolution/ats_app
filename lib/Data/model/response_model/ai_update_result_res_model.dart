import '../../../Domain/entities/ai_update_result_entity.dart';

class AiUpdateResultResModel extends AiUpdateResultEntity{
  AiUpdateResultResModel({
      bool? success, 
      String? message, 
      dynamic data, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _errors = errors;
}

  AiUpdateResultResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'];
    if (json['Errors'] != null) {
      _errors = [];
      // json['Errors'].forEach((v) {
      //   _errors?.add(Dynamic.fromJson(v));
      // });
    }
  }
  bool? _success;
  String? _message;
  dynamic _data;
  List<dynamic>? _errors;
AiUpdateResultResModel copyWith({  bool? success,
  String? message,
  dynamic data,
  List<dynamic>? errors,
}) => AiUpdateResultResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  dynamic get data => _data;
  List<dynamic>? get errors => _errors;

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