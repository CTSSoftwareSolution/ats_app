class VerifyOtpReqModel {
  VerifyOtpReqModel({
      String? email, 
      String? otp,}){
    _email = email;
    _otp = otp;
}

  VerifyOtpReqModel.fromJson(dynamic json) {
    _email = json['email'];
    _otp = json['otp'];
  }
  String? _email;
  String? _otp;
VerifyOtpReqModel copyWith({  String? email,
  String? otp,
}) => VerifyOtpReqModel(  email: email ?? _email,
  otp: otp ?? _otp,
);
  String? get email => _email;
  String? get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['otp'] = _otp;
    return map;
  }

}