class ChangePasswordReqModel {
  ChangePasswordReqModel({
      String? userId, 
      String? oldPassword, 
      String? newPassword,}){
    _userId = userId;
    _oldPassword = oldPassword;
    _newPassword = newPassword;
}

  ChangePasswordReqModel.fromJson(dynamic json) {
    _userId = json['user_id'];
    _oldPassword = json['old_password'];
    _newPassword = json['new_password'];
  }
  String? _userId;
  String? _oldPassword;
  String? _newPassword;
ChangePasswordReqModel copyWith({  String? userId,
  String? oldPassword,
  String? newPassword,
}) => ChangePasswordReqModel(  userId: userId ?? _userId,
  oldPassword: oldPassword ?? _oldPassword,
  newPassword: newPassword ?? _newPassword,
);
  String? get userId => _userId;
  String? get oldPassword => _oldPassword;
  String? get newPassword => _newPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['old_password'] = _oldPassword;
    map['new_password'] = _newPassword;
    return map;
  }

}
