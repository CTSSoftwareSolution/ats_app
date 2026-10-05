import '../../../Domain/entities/create_queue_entity.dart';

class CreateQueueResModel extends CreateQueueEntity{
  CreateQueueResModel({
      bool? success, 
      String? message,
    QueueData? data,
      dynamic type, 
      List<dynamic>? errors,}){
    _success = success;
    _message = message;
    _data = data;
    _type = type;
    _errors = errors;
}

  CreateQueueResModel.fromJson(dynamic json) {
    _success = json['Success'];
    _message = json['Message'];
    _data = json['Data'] != null ? QueueData.fromJson(json['Data']) : null;
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
  QueueData? _data;
  dynamic _type;
  List<dynamic>? _errors;
CreateQueueResModel copyWith({  bool? success,
  String? message,
  QueueData? data,
  dynamic type,
  List<dynamic>? errors,
}) => CreateQueueResModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  type: type ?? _type,
  errors: errors ?? _errors,
);
  bool? get success => _success;
  String? get message => _message;
  QueueData? get data => _data;
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

class QueueData {
  QueueData({
      num? inspectionId,}){
    _inspectionId = inspectionId;
}

  QueueData.fromJson(dynamic json) {
    _inspectionId = json['inspection_id'];
  }
  num? _inspectionId;
  QueueData copyWith({  num? inspectionId,
}) => QueueData(  inspectionId: inspectionId ?? _inspectionId,
);
  num? get inspectionId => _inspectionId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inspection_id'] = _inspectionId;
    return map;
  }

}