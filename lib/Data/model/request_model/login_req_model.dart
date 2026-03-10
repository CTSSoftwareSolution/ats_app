class LoginReqModel {
  LoginReqModel({
      String? username, 
      String? password,}){
    _username = username;
    _password = password;
}

  LoginReqModel.fromJson(dynamic json) {
    _username = json['username'];
    _password = json['password'];
  }
  String? _username;
  String? _password;
LoginReqModel copyWith({  String? username,
  String? password,
}) => LoginReqModel(  username: username ?? _username,
  password: password ?? _password,
);
  String? get username => _username;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }

}