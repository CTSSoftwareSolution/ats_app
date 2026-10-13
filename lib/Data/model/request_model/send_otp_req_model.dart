class SendOtpReqModel {
  SendOtpReqModel({
      String? email,}){
    _email = email;
}

  SendOtpReqModel.fromJson(dynamic json) {
    _email = json['email'];
  }
  String? _email;
SendOtpReqModel copyWith({  String? email,
}) => SendOtpReqModel(  email: email ?? _email,
);
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    return map;
  }

}