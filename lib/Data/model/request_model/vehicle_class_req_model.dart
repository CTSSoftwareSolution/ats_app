class VehicleClassReqModel {
  VehicleClassReqModel({
      num? pageNo, 
      num? pageSize, 
      String? searchText, 
      String? vehicleCategory,}){
    _pageNo = pageNo;
    _pageSize = pageSize;
    _searchText = searchText;
    _vehicleCategory = vehicleCategory;
}

  VehicleClassReqModel.fromJson(dynamic json) {
    _pageNo = json['page_no'];
    _pageSize = json['page_size'];
    _searchText = json['search_text'];
    _vehicleCategory = json['vehicle_category'];
  }
  num? _pageNo;
  num? _pageSize;
  String? _searchText;
  String? _vehicleCategory;
VehicleClassReqModel copyWith({  num? pageNo,
  num? pageSize,
  String? searchText,
  String? vehicleCategory,
}) => VehicleClassReqModel(  pageNo: pageNo ?? _pageNo,
  pageSize: pageSize ?? _pageSize,
  searchText: searchText ?? _searchText,
  vehicleCategory: vehicleCategory ?? _vehicleCategory,
);
  num? get pageNo => _pageNo;
  num? get pageSize => _pageSize;
  String? get searchText => _searchText;
  String? get vehicleCategory => _vehicleCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page_no'] = _pageNo;
    map['page_size'] = _pageSize;
    map['search_text'] = _searchText;
    map['vehicle_category'] = _vehicleCategory;
    return map;
  }

}