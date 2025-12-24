class VehicleClassReqModel {
  VehicleClassReqModel({
      String? vehicleClass, 
      String? search, 
      num? page, 
      num? pageSize,}){
    _vehicleClass = vehicleClass;
    _search = search;
    _page = page;
    _pageSize = pageSize;
}

  VehicleClassReqModel.fromJson(dynamic json) {
    _vehicleClass = json['vehicle_class'];
    _search = json['search'];
    _page = json['page'];
    _pageSize = json['pageSize'];
  }
  String? _vehicleClass;
  String? _search;
  num? _page;
  num? _pageSize;
VehicleClassReqModel copyWith({  String? vehicleClass,
  String? search,
  num? page,
  num? pageSize,
}) => VehicleClassReqModel(  vehicleClass: vehicleClass ?? _vehicleClass,
  search: search ?? _search,
  page: page ?? _page,
  pageSize: pageSize ?? _pageSize,
);
  String? get vehicleClass => _vehicleClass;
  String? get search => _search;
  num? get page => _page;
  num? get pageSize => _pageSize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_class'] = _vehicleClass;
    map['search'] = _search;
    map['page'] = _page;
    map['pageSize'] = _pageSize;
    return map;
  }

}