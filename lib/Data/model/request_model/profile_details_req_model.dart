class ProfileDetailsReqModel {
  ProfileDetailsReqModel({
      String? userId,}){
    _userId = userId;
}

  ProfileDetailsReqModel.fromJson(dynamic json) {
    _userId = json['user_id'];
  }
  String? _userId;
ProfileDetailsReqModel copyWith({  String? userId,
}) => ProfileDetailsReqModel(  userId: userId ?? _userId,
);
  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    return map;
  }

}