class NewInspectionSaveResModel {
  NewInspectionSaveResModel({
      bool? success, 
      String? message,
    NewSaveDataModel? data,
      dynamic type, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _type = type;
    _errors = errors;
}

  NewInspectionSaveResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'] != null ? NewSaveDataModel.fromJson(json['Data']) : null;
    _type = json['Type'];
    if (json['Errors'] != null) {
      _errors = [];
      // json['Errors'].forEach((v) {
      //   _errors?.add(Dynamic.fromJson(v));
      // });
    }
  }
  bool? _success;
  String? _message;
  NewSaveDataModel? _data;
  dynamic _type;
  List<dynamic>? _errors;
NewInspectionSaveResModel copyWith({  bool? success,
  String? message,
  NewSaveDataModel? data,
  dynamic type,
  List<dynamic>? errors,
}) => NewInspectionSaveResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  type: type ?? _type,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  NewSaveDataModel? get data => _data;
  dynamic get type => _type;
  List<dynamic>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    map['Type'] = _type;
    if (_errors != null) {
      map['Errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class NewSaveDataModel {
  NewSaveDataModel({
      num? questionId, 
      String? result, 
      num? filesUploaded, 
      List<Files>? files,}){
    _questionId = questionId;
    _result = result;
    _filesUploaded = filesUploaded;
    _files = files;
}

  NewSaveDataModel.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _result = json['result'];
    _filesUploaded = json['files_uploaded'];
    if (json['files'] != null) {
      _files = [];
      json['files'].forEach((v) {
        _files?.add(Files.fromJson(v));
      });
    }
  }
  num? _questionId;
  String? _result;
  num? _filesUploaded;
  List<Files>? _files;
  NewSaveDataModel copyWith({  num? questionId,
  String? result,
  num? filesUploaded,
  List<Files>? files,
}) => NewSaveDataModel(  questionId: questionId ?? _questionId,
  result: result ?? _result,
  filesUploaded: filesUploaded ?? _filesUploaded,
  files: files ?? _files,
);
  num? get questionId => _questionId;
  String? get result => _result;
  num? get filesUploaded => _filesUploaded;
  List<Files>? get files => _files;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['result'] = _result;
    map['files_uploaded'] = _filesUploaded;
    if (_files != null) {
      map['files'] = _files?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Files {
  Files({
      num? labelId, 
      String? filename, 
      num? latitude, 
      num? longitude,}){
    _labelId = labelId;
    _filename = filename;
    _latitude = latitude;
    _longitude = longitude;
}

  Files.fromJson(dynamic json) {
    _labelId = json['label_id'];
    _filename = json['filename'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }
  num? _labelId;
  String? _filename;
  num? _latitude;
  num? _longitude;
Files copyWith({  num? labelId,
  String? filename,
  num? latitude,
  num? longitude,
}) => Files(  labelId: labelId ?? _labelId,
  filename: filename ?? _filename,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
);
  num? get labelId => _labelId;
  String? get filename => _filename;
  num? get latitude => _latitude;
  num? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label_id'] = _labelId;
    map['filename'] = _filename;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    return map;
  }

}