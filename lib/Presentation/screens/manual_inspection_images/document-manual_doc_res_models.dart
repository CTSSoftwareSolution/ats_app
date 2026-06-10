class DocumentManualDocResModels {
  DocumentManualDocResModels({
      bool? status, 
      String? message, 
      String? field, 
      dynamic data,}){
    _status = status;
    _message = message;
    _field = field;
    _data = data;
}

  DocumentManualDocResModels.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _field = json['field'];
    _data = json['data'];
  }
  bool? _status;
  String? _message;
  String? _field;
  dynamic _data;
DocumentManualDocResModels copyWith({  bool? status,
  String? message,
  String? field,
  dynamic data,
}) => DocumentManualDocResModels(  status: status ?? _status,
  message: message ?? _message,
  field: field ?? _field,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  String? get field => _field;
  dynamic get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['field'] = _field;
    map['data'] = _data;
    return map;
  }

}