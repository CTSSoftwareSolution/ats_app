class LoginReqModel {
  LoginReqModel({
      String? email, 
      String? password,}){
    _email = email;
    _password = password;
}

  LoginReqModel.fromJson(dynamic json) {
    _email = json['email'];
    _password = json['password'];
  }
  String? _email;
  String? _password;
  LoginReqModel copyWith({  String? email,
  String? password,
}) => LoginReqModel(  email: email ?? _email,
  password: password ?? _password,
);
  String? get email => _email;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['password'] = _password;
    return map;
  }

}