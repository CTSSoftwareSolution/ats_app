import 'package:ats_app/Domain/entities/send_otp_entity.dart';

class SendOtpResModel extends SendOtpEntity {
  SendOtpResModel({
      bool? success, 
      String? message,
    sendOtpData? data,
      dynamic type, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _type = type;
    _errors = errors;
}

  SendOtpResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'] != null ? sendOtpData.fromJson(json['Data']) : null;
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
  sendOtpData? _data;
  dynamic _type;
  List<dynamic>? _errors;
SendOtpResModel copyWith({  bool? success,
  String? message,
  sendOtpData? data,
  dynamic type,
  List<dynamic>? errors,
}) => SendOtpResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  type: type ?? _type,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  sendOtpData? get data => _data;
  dynamic get type => _type;
  List<dynamic>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    map['Type'] = _type;
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class sendOtpData {
  sendOtpData({
      num? validForMinutes,}){
    _validForMinutes = validForMinutes;
}

  sendOtpData.fromJson(dynamic json) {
    _validForMinutes = json['valid_for_minutes'];
  }
  num? _validForMinutes;
  sendOtpData copyWith({  num? validForMinutes,
}) => sendOtpData(  validForMinutes: validForMinutes ?? _validForMinutes,
);
  num? get validForMinutes => _validForMinutes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['valid_for_minutes'] = _validForMinutes;
    return map;
  }

}