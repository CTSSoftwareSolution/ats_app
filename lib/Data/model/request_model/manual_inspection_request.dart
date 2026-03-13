class ManualInspectionRequest {
  ManualInspectionRequest({
      num? pageNo, 
      num? pageSize, 
      String? searchText,}){
    _pageNo = pageNo;
    _pageSize = pageSize;
    _searchText = searchText;
}

  ManualInspectionRequest.fromJson(dynamic json) {
    _pageNo = json['page_no'];
    _pageSize = json['page_size'];
    _searchText = json['search_text'];
  }
  num? _pageNo;
  num? _pageSize;
  String? _searchText;
ManualInspectionRequest copyWith({  num? pageNo,
  num? pageSize,
  String? searchText,
}) => ManualInspectionRequest(  pageNo: pageNo ?? _pageNo,
  pageSize: pageSize ?? _pageSize,
  searchText: searchText ?? _searchText,
);
  num? get pageNo => _pageNo;
  num? get pageSize => _pageSize;
  String? get searchText => _searchText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page_no'] = _pageNo;
    map['page_size'] = _pageSize;
    map['search_text'] = _searchText;
    return map;
  }

}