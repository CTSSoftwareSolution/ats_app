import 'package:ats_app/Domain/entities/login_entity.dart';

class LoginResModel extends LoginEntity{
  LoginResModel({
      bool? status, 
      String? message, 
      List<LoginDataModel>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  LoginResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(LoginDataModel.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<LoginDataModel>? _data;
  LoginResModel copyWith({  bool? status,
  String? message,
  List<LoginDataModel>? data,
}) => LoginResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<LoginDataModel>? get data => _data;

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

class LoginDataModel {
  LoginDataModel({
      num? userId, 
      String? fullName, 
      String? email, 
      String? address, 
      String? mobileNumber, 
      String? carName, 
      String? carBrand, 
      String? carModel, 
      String? imageUpload, 
      String? token,}){
    _userId = userId;
    _fullName = fullName;
    _email = email;
    _address = address;
    _mobileNumber = mobileNumber;
    _carName = carName;
    _carBrand = carBrand;
    _carModel = carModel;
    _imageUpload = imageUpload;
    _token = token;
}

  LoginDataModel.fromJson(dynamic json) {
    _userId = json['user_id'];
    _fullName = json['full_name'];
    _email = json['email'];
    _address = json['address'];
    _mobileNumber = json['mobile_number'];
    _carName = json['car_name'];
    _carBrand = json['car_brand'];
    _carModel = json['car_model'];
    _imageUpload = json['image_upload'];
    _token = json['token'];
  }
  num? _userId;
  String? _fullName;
  String? _email;
  String? _address;
  String? _mobileNumber;
  String? _carName;
  String? _carBrand;
  String? _carModel;
  String? _imageUpload;
  String? _token;
  LoginDataModel copyWith({  num? userId,
  String? fullName,
  String? email,
  String? address,
  String? mobileNumber,
  String? carName,
  String? carBrand,
  String? carModel,
  String? imageUpload,
  String? token,
}) => LoginDataModel(  userId: userId ?? _userId,
  fullName: fullName ?? _fullName,
  email: email ?? _email,
  address: address ?? _address,
  mobileNumber: mobileNumber ?? _mobileNumber,
  carName: carName ?? _carName,
  carBrand: carBrand ?? _carBrand,
  carModel: carModel ?? _carModel,
  imageUpload: imageUpload ?? _imageUpload,
  token: token ?? _token,
);
  num? get userId => _userId;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get address => _address;
  String? get mobileNumber => _mobileNumber;
  String? get carName => _carName;
  String? get carBrand => _carBrand;
  String? get carModel => _carModel;
  String? get imageUpload => _imageUpload;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['full_name'] = _fullName;
    map['email'] = _email;
    map['address'] = _address;
    map['mobile_number'] = _mobileNumber;
    map['car_name'] = _carName;
    map['car_brand'] = _carBrand;
    map['car_model'] = _carModel;
    map['image_upload'] = _imageUpload;
    map['token'] = _token;
    return map;
  }

}