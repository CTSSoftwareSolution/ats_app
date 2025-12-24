class SliderResModel {
  SliderResModel({
      bool? status, 
      String? message, 
      List<SliderData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  SliderResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(SliderData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<SliderData>? _data;
SliderResModel copyWith({  bool? status,
  String? message,
  List<SliderData>? data,
}) => SliderResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<SliderData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SliderData {
  SliderData({
      num? id, 
      String? images, 
      String? title, 
      String? description,}){
    _id = id;
    _images = images;
    _title = title;
    _description = description;
}

  SliderData.fromJson(dynamic json) {
    _id = json['Id'];
    _images = json['images'];
    _title = json['title'];
    _description = json['description'];
  }
  num? _id;
  String? _images;
  String? _title;
  String? _description;
  SliderData copyWith({  num? id,
  String? images,
  String? title,
  String? description,
}) => SliderData(  id: id ?? _id,
  images: images ?? _images,
  title: title ?? _title,
  description: description ?? _description,
);
  num? get id => _id;
  String? get images => _images;
  String? get title => _title;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['images'] = _images;
    map['title'] = _title;
    map['description'] = _description;
    return map;
  }

}