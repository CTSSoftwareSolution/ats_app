class LoginResModel {
  LoginResModel({
      bool? success, 
      String? message,
    LoginDataModel? data,
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _errors = errors;
}

  LoginResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'] != null ? LoginDataModel.fromJson(json['Data']) : null;
    if (json['Errors'] != null) {
      _errors = [];
      // json['Errors'].forEach((v) {
      //   _errors?.add(Dynamic.fromJson(v));
      // });
    }
  }
  bool? _success;
  String? _message;
  LoginDataModel? _data;
  List<dynamic>? _errors;
LoginResModel copyWith({  bool? success,
  String? message,
  LoginDataModel? data,
  List<dynamic>? errors,
}) => LoginResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  LoginDataModel? get data => _data;
  List<dynamic>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class LoginDataModel {
  LoginDataModel({
      String? accessToken, 
      bool? mustChangePassword, 
      List<String>? roles, 
      String? userFullName, 
      String? userId,}){
    _accessToken = accessToken;
    _mustChangePassword = mustChangePassword;
    _roles = roles;
    _userFullName = userFullName;
    _userId = userId;
}

  LoginDataModel.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _mustChangePassword = json['must_change_password'];
    _roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    _userFullName = json['user_full_name'];
    _userId = json['user_id'];
  }
  String? _accessToken;
  bool? _mustChangePassword;
  List<String>? _roles;
  String? _userFullName;
  String? _userId;
  LoginDataModel copyWith({  String? accessToken,
  bool? mustChangePassword,
  List<String>? roles,
  String? userFullName,
  String? userId,
}) => LoginDataModel(  accessToken: accessToken ?? _accessToken,
  mustChangePassword: mustChangePassword ?? _mustChangePassword,
  roles: roles ?? _roles,
  userFullName: userFullName ?? _userFullName,
  userId: userId ?? _userId,
);
  String? get accessToken => _accessToken;
  bool? get mustChangePassword => _mustChangePassword;
  List<String>? get roles => _roles;
  String? get userFullName => _userFullName;
  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['must_change_password'] = _mustChangePassword;
    map['roles'] = _roles;
    map['user_full_name'] = _userFullName;
    map['user_id'] = _userId;
    return map;
  }

}