import 'package:ats_app/Domain/entities/reset_password_entity.dart';

class ResetPasswordResModel extends ResetPasswordEntity{
  ResetPasswordResModel({
      bool? success, 
      String? message, 
      dynamic data, 
      dynamic type, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _type = type;
    _errors = errors;
}

  ResetPasswordResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'];
    _type = json['Type'];
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
  dynamic _type;
  List<dynamic>? _errors;
ResetPasswordResModel copyWith({  bool? success,
  String? message,
  dynamic data,
  dynamic type,
  List<dynamic>? errors,
}) => ResetPasswordResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  type: type ?? _type,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  dynamic get data => _data;
  dynamic get type => _type;
  List<dynamic>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    map['Data'] = _data;
    map['Type'] = _type;
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}