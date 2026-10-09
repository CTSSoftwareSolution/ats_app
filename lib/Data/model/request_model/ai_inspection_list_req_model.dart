class AiInspectionListReqModel {
  AiInspectionListReqModel({
      num? pageNo, 
      num? pageSize, 
      String? searchText, 
      dynamic status,}){
    _pageNo = pageNo;
    _pageSize = pageSize;
    _searchText = searchText;
    _status = status;
}

  AiInspectionListReqModel.fromJson(dynamic json) {
    _pageNo = json['page_no'];
    _pageSize = json['page_size'];
    _searchText = json['search_text'];
    _status = json['status'];
  }
  num? _pageNo;
  num? _pageSize;
  String? _searchText;
  dynamic _status;
AiInspectionListReqModel copyWith({  num? pageNo,
  num? pageSize,
  String? searchText,
  dynamic status,
}) => AiInspectionListReqModel(  pageNo: pageNo ?? _pageNo,
  pageSize: pageSize ?? _pageSize,
  searchText: searchText ?? _searchText,
  status: status ?? _status,
);
  num? get pageNo => _pageNo;
  num? get pageSize => _pageSize;
  String? get searchText => _searchText;
  dynamic get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page_no'] = _pageNo;
    map['page_size'] = _pageSize;
    map['search_text'] = _searchText;
    map['status'] = _status;
    return map;
  }

}