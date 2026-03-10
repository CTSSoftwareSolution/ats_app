class LaneListModel {
  LaneListModel({
      bool? success, 
      String? message, 
      List<LaneListData>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  LaneListModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(LaneListData.fromJson(v));
      });
    }
  }
  bool? _success;
  String? _message;
  List<LaneListData>? _data;
LaneListModel copyWith({  bool? success,
  String? message,
  List<LaneListData>? data,
}) => LaneListModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  List<LaneListData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class LaneListData {
  LaneListData({
      num? id, 
      String? laneCode, 
      String? laneName, 
      String? description, 
      bool? isActive,}){
    _id = id;
    _laneCode = laneCode;
    _laneName = laneName;
    _description = description;
    _isActive = isActive;
}

  LaneListData.fromJson(dynamic json) {
    _id = json['id'];
    _laneCode = json['lane_code'];
    _laneName = json['lane_name'];
    _description = json['description'];
    _isActive = json['is_active'];
  }
  num? _id;
  String? _laneCode;
  String? _laneName;
  String? _description;
  bool? _isActive;
  LaneListData copyWith({  num? id,
  String? laneCode,
  String? laneName,
  String? description,
  bool? isActive,
}) => LaneListData(  id: id ?? _id,
  laneCode: laneCode ?? _laneCode,
  laneName: laneName ?? _laneName,
  description: description ?? _description,
  isActive: isActive ?? _isActive,
);
  num? get id => _id;
  String? get laneCode => _laneCode;
  String? get laneName => _laneName;
  String? get description => _description;
  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['lane_code'] = _laneCode;
    map['lane_name'] = _laneName;
    map['description'] = _description;
    map['is_active'] = _isActive;
    return map;
  }

}