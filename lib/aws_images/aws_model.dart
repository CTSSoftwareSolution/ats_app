import 'package:ats_app/aws_images/aws_entity.dart';

class AwsModel extends AwsEntity{
  AwsModel({
    bool? status,
    String? url,}){
    _status = status;
    _url = url;
  }

  AwsModel.fromJson(dynamic json) {
    _status = json['status'];
    _url = json['url'];
  }
  bool? _status;
  String? _url;
  AwsModel copyWith({  bool? status,
    String? url,
  }) => AwsModel(  status: status ?? _status,
    url: url ?? _url,
  );
  bool? get status => _status;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['url'] = _url;
    return map;
  }

}