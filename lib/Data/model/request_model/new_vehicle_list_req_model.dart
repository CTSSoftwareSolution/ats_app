class NewVehicleListReqModel {
  NewVehicleListReqModel({
      num? pageNo, 
      num? pageSize, 
      num? status,}){
    _pageNo = pageNo;
    _pageSize = pageSize;
    _status = status;
}

  NewVehicleListReqModel.fromJson(dynamic json) {
    _pageNo = json['page_no'];
    _pageSize = json['page_size'];
    _status = json['status'];
  }
  num? _pageNo;
  num? _pageSize;
  num? _status;
NewVehicleListReqModel copyWith({  num? pageNo,
  num? pageSize,
  num? status,
}) => NewVehicleListReqModel(  pageNo: pageNo ?? _pageNo,
  pageSize: pageSize ?? _pageSize,
  status: status ?? _status,
);
  num? get pageNo => _pageNo;
  num? get pageSize => _pageSize;
  num? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page_no'] = _pageNo;
    map['page_size'] = _pageSize;
    map['status'] = _status;
    return map;
  }

}