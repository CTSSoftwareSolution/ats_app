class ResetPasswordReqModel {
  ResetPasswordReqModel({
      String? email, 
      String? newPassword, 
      String? otp,}){
    _email = email;
    _newPassword = newPassword;
    _otp = otp;
}

  ResetPasswordReqModel.fromJson(dynamic json) {
    _email = json['email'];
    _newPassword = json['new_password'];
    _otp = json['otp'];
  }
  String? _email;
  String? _newPassword;
  String? _otp;
ResetPasswordReqModel copyWith({  String? email,
  String? newPassword,
  String? otp,
}) => ResetPasswordReqModel(  email: email ?? _email,
  newPassword: newPassword ?? _newPassword,
  otp: otp ?? _otp,
);
  String? get email => _email;
  String? get newPassword => _newPassword;
  String? get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['new_password'] = _newPassword;
    map['otp'] = _otp;
    return map;
  }

}